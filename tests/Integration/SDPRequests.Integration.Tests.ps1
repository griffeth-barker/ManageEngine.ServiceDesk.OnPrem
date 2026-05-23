#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

<#
    Integration tests for ManageEngine.ServiceDesk.OnPrem.Requests.

    Required environment variables:
        SDP_BASE_URI              - Base URI of the SDP instance (e.g. https://sdp.corp.local:8080)
        SDP_PORTAL_ID             - (Optional) Portal ID, defaults to 1

    Required SecretsManagement vault secret:
        ZohoSdpOnPremApiKey       - Technician API key as a SecureString

    Optional environment variables (used to scope tests to specific records):
        SDP_TEST_REQUEST_ID       - An existing request ID to use for read tests

    Optional environment variables (used by lifecycle tests to satisfy mandatory fields):
        SDP_TEST_REQUESTER_NAME   - Requester name required by the SDP instance (e.g. 'Jane Smith')
        SDP_TEST_CATEGORY_NAME    - Category name required by the SDP instance (e.g. 'Hardware')
        SDP_TEST_PRIORITY_NAME    - Priority name required by the SDP instance (e.g. 'High')
        SDP_TEST_OWNER_NAME       - Technician name for worklog owner, if mandatory on the instance
#>

BeforeAll {
    $repoRoot         = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $coreManifest     = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Core'     'ManageEngine.ServiceDesk.OnPrem.Core.psd1'
    $requestsManifest = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Requests' 'ManageEngine.ServiceDesk.OnPrem.Requests.psd1'

    Import-Module $coreManifest     -Force
    Import-Module $requestsManifest -Force

    if (-not $env:SDP_BASE_URI) { throw 'SDP_BASE_URI environment variable is required.' }

    $secureKey = Get-Secret -Name 'ZohoSdpOnPremApiKey'
    $portalId  = if ($env:SDP_PORTAL_ID) { [int]$env:SDP_PORTAL_ID } else { 1 }

    $connectParams = @{
        BaseUri      = $env:SDP_BASE_URI
        TechnicianKey = $secureKey
        PortalId     = $portalId
    }
    if ($env:SDP_SKIP_CERTIFICATE_CHECK -eq '1') { $connectParams['SkipCertificateCheck'] = $true }

    Connect-SDPService @connectParams
}

AfterAll {
    Disconnect-SDPService
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Requests' -ErrorAction SilentlyContinue
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Core'     -ErrorAction SilentlyContinue
}

Describe 'Get-SDPRequest' -Tag 'Integration' {
    It 'returns a list of requests' {
        $results = Get-SDPRequest -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPRequest'
    }

    It 'returns a single request by Id' -Skip:(-not $env:SDP_TEST_REQUEST_ID) {
        $result = Get-SDPRequest -Id $env:SDP_TEST_REQUEST_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_REQUEST_ID
    }
}

Describe 'Request lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdRequestId  = $null
        $script:createdNoteId     = $null
        $script:createdWorklogId  = $null

        $testSubject  = "Pester integration test $(Get-Date -Format 'yyyyMMddHHmmss')"
        $createParams = @{
            Subject     = $testSubject
            Description = 'Automated Pester integration test — safe to delete.'
        }
        if ($env:SDP_TEST_REQUESTER_NAME) { $createParams['RequesterName'] = $env:SDP_TEST_REQUESTER_NAME }
        if ($env:SDP_TEST_CATEGORY_NAME)  { $createParams['CategoryName']  = $env:SDP_TEST_CATEGORY_NAME }
        if ($env:SDP_TEST_PRIORITY_NAME)  { $createParams['PriorityName']  = $env:SDP_TEST_PRIORITY_NAME }

        try {
            $created = New-SDPRequest @createParams
            $script:createdRequestId  = $created.Id
            $script:createdSubject    = $created.Subject
        } catch {
            Write-Warning "Request creation failed: $_"
            Write-Warning 'Lifecycle tests will be skipped. Set SDP_TEST_REQUESTER_NAME / SDP_TEST_CATEGORY_NAME / SDP_TEST_PRIORITY_NAME if your instance enforces mandatory fields.'
        }
    }

    AfterAll {
        if ($script:createdRequestId) {
            try { Set-SDPRequest -Id $script:createdRequestId -StatusName 'Closed' } catch { }
        }
    }

    It 'creates a new request' {
        $script:createdRequestId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created request by Id' -Skip:(-not $script:createdRequestId) {
        $result = Get-SDPRequest -Id $script:createdRequestId
        $result.Id | Should -Be $script:createdRequestId
    }

    It 'updates the request subject' -Skip:(-not $script:createdRequestId) {
        $updated = Set-SDPRequest -Id $script:createdRequestId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPRequest'
    }

    It 'adds a note to the request' -Skip:(-not $script:createdRequestId) {
        $note = New-SDPRequestNote -RequestId $script:createdRequestId -Description 'Pester test note.'
        $note.GetType().Name | Should -Be 'SDPRequestNote'
        $script:createdNoteId = $note.Id
    }

    It 'retrieves notes for the request' -Skip:(-not $script:createdRequestId) {
        $notes = Get-SDPRequestNote -RequestId $script:createdRequestId
        $notes | Should -Not -BeNullOrEmpty
    }

    It 'updates the note' -Skip:(-not $script:createdNoteId) {
        $updated = Set-SDPRequestNote -RequestId $script:createdRequestId -Id $script:createdNoteId -Description 'Updated Pester note.'
        $updated.GetType().Name | Should -Be 'SDPRequestNote'
    }

    It 'removes the note' -Skip:(-not $script:createdNoteId) {
        { Remove-SDPRequestNote -RequestId $script:createdRequestId -Id $script:createdNoteId -Confirm:$false } | Should -Not -Throw
    }

    It 'adds a worklog to the request' -Skip:(-not $script:createdRequestId) {
        $worklogParams = @{
            RequestId        = $script:createdRequestId
            Description      = 'Pester worklog'
            TimeSpentHours   = '0'
            TimeSpentMinutes = '15'
        }
        if ($env:SDP_TEST_OWNER_NAME) { $worklogParams['OwnerName'] = $env:SDP_TEST_OWNER_NAME }
        $worklog = New-SDPRequestWorklog @worklogParams
        $worklog.GetType().Name | Should -Be 'SDPRequestWorklog'
        $script:createdWorklogId = $worklog.Id
    }

    It 'retrieves worklogs for the request' -Skip:(-not $script:createdRequestId) {
        $worklogs = Get-SDPRequestWorklog -RequestId $script:createdRequestId
        $worklogs | Should -Not -BeNullOrEmpty
    }

    It 'removes the worklog' -Skip:(-not $script:createdWorklogId) {
        { Remove-SDPRequestWorklog -RequestId $script:createdRequestId -Id $script:createdWorklogId -Confirm:$false } | Should -Not -Throw
    }

    It 'sets a resolution on the request' -Skip:(-not $script:createdRequestId) {
        $resolution = New-SDPRequestResolution -RequestId $script:createdRequestId -Content 'Resolved by Pester test.'
        $resolution.GetType().Name | Should -Be 'SDPRequestResolution'
    }

    It 'retrieves the resolution' -Skip:(-not $script:createdRequestId) {
        $resolution = Get-SDPRequestResolution -RequestId $script:createdRequestId
        $resolution.GetType().Name | Should -Be 'SDPRequestResolution'
        $resolution.Content | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-SDPApproval' -Tag 'Integration' {
    It 'returns pending approvals without error' {
        { Get-SDPApproval } | Should -Not -Throw
    }
}
