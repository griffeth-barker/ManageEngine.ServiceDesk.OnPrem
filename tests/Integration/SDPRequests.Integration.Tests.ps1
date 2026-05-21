#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

<#
    Integration tests for ServiceDesk.OnPrem.Requests.

    Required environment variables:
        SDP_BASE_URI        - Base URI of the SDP instance (e.g. https://sdp.corp.local:8080)
        SDP_PORTAL_ID       - (Optional) Portal ID, defaults to 1

    Required SecretsManagement vault secret:
        ZohoSdpOnPremApiKey - Technician API key as a SecureString

    Optional environment variables (used to scope tests to specific records):
        SDP_TEST_REQUEST_ID - An existing request ID to use for read tests
#>

BeforeAll {
    $moduleName   = 'ServiceDesk.OnPrem.Requests'
    $repoRoot     = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $manifestPath = Join-Path $repoRoot $moduleName "$moduleName.psd1"

    Import-Module $manifestPath -Force

    if (-not $env:SDP_BASE_URI) { throw 'SDP_BASE_URI environment variable is required.' }

    $secureKey = Get-Secret -Name 'ZohoSdpOnPremApiKey'
    $portalId  = if ($env:SDP_PORTAL_ID) { [int]$env:SDP_PORTAL_ID } else { 1 }

    Connect-SDPService -BaseUri $env:SDP_BASE_URI -TechnicianKey $secureKey -PortalId $portalId
}

AfterAll {
    Disconnect-SDPService
    Remove-Module 'ServiceDesk.OnPrem.Requests' -ErrorAction SilentlyContinue
}

Describe 'Get-SDPRequest' -Tag 'Integration' {
    It 'returns a list of requests' {
        $results = Get-SDPRequest -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0] | Should -BeOfType 'SDPRequest'
    }

    It 'returns a single request by Id' -Skip:(-not $env:SDP_TEST_REQUEST_ID) {
        $result = Get-SDPRequest -Id $env:SDP_TEST_REQUEST_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_REQUEST_ID
    }
}

Describe 'Request lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:testSubject = "Pester integration test $(Get-Date -Format 'yyyyMMddHHmmss')"
    }

    AfterAll {
        if ($script:createdRequestId) {
            Remove-SDPRequest -Id $script:createdRequestId -Confirm:$false -ErrorAction SilentlyContinue
        }
    }

    It 'creates a new request' {
        $request = New-SDPRequest -Subject $script:testSubject -Description 'Automated Pester integration test — safe to delete.'
        $request | Should -Not -BeNullOrEmpty
        $request | Should -BeOfType 'SDPRequest'
        $request.Subject | Should -Be $script:testSubject
        $script:createdRequestId = $request.Id
    }

    It 'retrieves the created request by Id' {
        $result = Get-SDPRequest -Id $script:createdRequestId
        $result.Id | Should -Be $script:createdRequestId
    }

    It 'updates the request subject' {
        $updated = Set-SDPRequest -Id $script:createdRequestId -Description 'Updated by Pester.'
        $updated | Should -BeOfType 'SDPRequest'
    }

    It 'adds a note to the request' {
        $note = New-SDPRequestNote -RequestId $script:createdRequestId -Description 'Pester test note.'
        $note | Should -BeOfType 'SDPRequestNote'
        $script:createdNoteId = $note.Id
    }

    It 'retrieves notes for the request' {
        $notes = Get-SDPRequestNote -RequestId $script:createdRequestId
        $notes | Should -Not -BeNullOrEmpty
    }

    It 'updates the note' {
        $updated = Set-SDPRequestNote -RequestId $script:createdRequestId -Id $script:createdNoteId -Description 'Updated Pester note.'
        $updated | Should -BeOfType 'SDPRequestNote'
    }

    It 'removes the note' {
        { Remove-SDPRequestNote -RequestId $script:createdRequestId -Id $script:createdNoteId -Confirm:$false } | Should -Not -Throw
    }

    It 'adds a worklog to the request' {
        $worklog = New-SDPRequestWorklog -RequestId $script:createdRequestId -Description 'Pester worklog' -TimeSpentHours '0' -TimeSpentMinutes '15'
        $worklog | Should -BeOfType 'SDPRequestWorklog'
        $script:createdWorklogId = $worklog.Id
    }

    It 'retrieves worklogs for the request' {
        $worklogs = Get-SDPRequestWorklog -RequestId $script:createdRequestId
        $worklogs | Should -Not -BeNullOrEmpty
    }

    It 'removes the worklog' {
        { Remove-SDPRequestWorklog -RequestId $script:createdRequestId -Id $script:createdWorklogId -Confirm:$false } | Should -Not -Throw
    }

    It 'sets a resolution on the request' {
        $resolution = New-SDPRequestResolution -RequestId $script:createdRequestId -Content 'Resolved by Pester test.'
        $resolution | Should -BeOfType 'SDPRequestResolution'
    }

    It 'retrieves the resolution' {
        $resolution = Get-SDPRequestResolution -RequestId $script:createdRequestId
        $resolution | Should -BeOfType 'SDPRequestResolution'
        $resolution.Content | Should -Not -BeNullOrEmpty
    }

    It 'deletes the request' {
        { Remove-SDPRequest -Id $script:createdRequestId -Confirm:$false } | Should -Not -Throw
        $script:createdRequestId = $null
    }
}

Describe 'Get-SDPApproval' -Tag 'Integration' {
    It 'returns pending approvals without error' {
        { Get-SDPApproval } | Should -Not -Throw
    }
}
