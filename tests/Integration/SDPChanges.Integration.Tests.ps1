#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

<#
    Integration tests for ManageEngine.ServiceDesk.OnPrem.Changes.

    Required environment variables:
        SDP_BASE_URI              - Base URI of the SDP instance (e.g. https://sdp.corp.local:8080)
        SDP_PORTAL_ID             - (Optional) Portal ID, defaults to 1

    Required SecretsManagement vault secret:
        ZohoSdpOnPremApiKey       - Technician API key as a SecureString

    Optional environment variables (used to scope tests to specific records):
        SDP_TEST_CHANGE_ID        - An existing change ID to use for read tests

    Optional environment variables (used by lifecycle tests to satisfy mandatory fields):
        SDP_TEST_CHANGE_TYPE_NAME - Change type name required by the SDP instance (e.g. 'Normal')
        SDP_TEST_PRIORITY_NAME    - Priority name required by the SDP instance (e.g. 'High')
        SDP_TEST_TECHNICIAN_NAME  - Technician name required by the SDP instance (e.g. 'Bob Jones')
        SDP_TEST_OWNER_NAME       - Technician name for worklog owner, if mandatory on the instance
#>

BeforeAll {
    $repoRoot       = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $coreManifest   = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Core'    'ManageEngine.ServiceDesk.OnPrem.Core.psd1'
    $changesManifest = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Changes' 'ManageEngine.ServiceDesk.OnPrem.Changes.psd1'

    Import-Module $coreManifest    -Force
    Import-Module $changesManifest -Force

    if (-not $env:SDP_BASE_URI) { throw 'SDP_BASE_URI environment variable is required.' }

    $secureKey = Get-Secret -Name 'ZohoSdpOnPremApiKey'
    $portalId  = if ($env:SDP_PORTAL_ID) { [int]$env:SDP_PORTAL_ID } else { 1 }

    $connectParams = @{
        BaseUri       = $env:SDP_BASE_URI
        TechnicianKey = $secureKey
        PortalId      = $portalId
    }
    if ($env:SDP_SKIP_CERTIFICATE_CHECK -eq '1') { $connectParams['SkipCertificateCheck'] = $true }

    Connect-SDPService @connectParams
}

AfterAll {
    Disconnect-SDPService
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Changes' -ErrorAction SilentlyContinue
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Core'    -ErrorAction SilentlyContinue
}

Describe 'Get-SDPChange' -Tag 'Integration' {
    It 'returns a list of changes' {
        $results = Get-SDPChange -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPChange'
    }

    It 'returns a single change by Id' -Skip:(-not $env:SDP_TEST_CHANGE_ID) {
        $result = Get-SDPChange -Id $env:SDP_TEST_CHANGE_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_CHANGE_ID
    }
}

Describe 'Change lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdChangeId   = $null
        $script:createdNoteId     = $null
        $script:createdTaskId     = $null
        $script:createdWorklogId  = $null

        $testTitle    = "Pester integration test $(Get-Date -Format 'yyyyMMddHHmmss')"
        $createParams = @{
            Title       = $testTitle
            Description = 'Automated Pester integration test — safe to delete.'
        }
        if ($env:SDP_TEST_CHANGE_TYPE_NAME) { $createParams['ChangeTypeName'] = $env:SDP_TEST_CHANGE_TYPE_NAME }
        if ($env:SDP_TEST_PRIORITY_NAME)    { $createParams['PriorityName']   = $env:SDP_TEST_PRIORITY_NAME }
        if ($env:SDP_TEST_TECHNICIAN_NAME)  { $createParams['TechnicianName'] = $env:SDP_TEST_TECHNICIAN_NAME }

        try {
            $created = New-SDPChange @createParams
            $script:createdChangeId = $created.Id
        } catch {
            Write-Warning "Change creation failed: $_"
            Write-Warning 'Lifecycle tests will be skipped. Set SDP_TEST_CHANGE_TYPE_NAME / SDP_TEST_PRIORITY_NAME / SDP_TEST_TECHNICIAN_NAME if your instance enforces mandatory fields.'
        }
    }

    AfterAll {
        if ($script:createdChangeId) {
            try { Close-SDPChange -Id $script:createdChangeId -Confirm:$false } catch { }
        }
    }

    It 'creates a new change' {
        $script:createdChangeId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created change by Id' -Skip:(-not $script:createdChangeId) {
        $result = Get-SDPChange -Id $script:createdChangeId
        $result.Id | Should -Be $script:createdChangeId
    }

    It 'updates the change description' -Skip:(-not $script:createdChangeId) {
        $updated = Set-SDPChange -Id $script:createdChangeId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPChange'
    }

    It 'adds a note to the change' -Skip:(-not $script:createdChangeId) {
        $note = New-SDPChangeNote -ChangeId $script:createdChangeId -Description 'Pester test note.'
        $note.GetType().Name | Should -Be 'SDPChangeNote'
        $script:createdNoteId = $note.Id
    }

    It 'retrieves notes for the change' -Skip:(-not $script:createdChangeId) {
        $notes = Get-SDPChangeNote -ChangeId $script:createdChangeId
        $notes | Should -Not -BeNullOrEmpty
    }

    It 'updates the note' -Skip:(-not $script:createdNoteId) {
        $updated = Set-SDPChangeNote -ChangeId $script:createdChangeId -Id $script:createdNoteId -Description 'Updated Pester note.'
        $updated.GetType().Name | Should -Be 'SDPChangeNote'
    }

    It 'removes the note' -Skip:(-not $script:createdNoteId) {
        { Remove-SDPChangeNote -ChangeId $script:createdChangeId -Id $script:createdNoteId -Confirm:$false } | Should -Not -Throw
    }

    It 'creates a task on the change' -Skip:(-not $script:createdChangeId) {
        $task = New-SDPChangeTask -ChangeId $script:createdChangeId -Title 'Pester test task'
        $task.GetType().Name | Should -Be 'SDPChangeTask'
        $script:createdTaskId = $task.Id
    }

    It 'retrieves tasks for the change' -Skip:(-not $script:createdChangeId) {
        $tasks = Get-SDPChangeTask -ChangeId $script:createdChangeId
        $tasks | Should -Not -BeNullOrEmpty
    }

    It 'updates the task' -Skip:(-not $script:createdTaskId) {
        $updated = Set-SDPChangeTask -ChangeId $script:createdChangeId -Id $script:createdTaskId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPChangeTask'
    }

    It 'removes the task' -Skip:(-not $script:createdTaskId) {
        { Remove-SDPChangeTask -ChangeId $script:createdChangeId -Id $script:createdTaskId -Confirm:$false } | Should -Not -Throw
    }

    It 'adds a worklog to the change' -Skip:(-not $script:createdChangeId) {
        $worklogParams = @{
            ChangeId    = $script:createdChangeId
            Description = 'Pester worklog'
        }
        if ($env:SDP_TEST_OWNER_NAME) { $worklogParams['OwnerName'] = $env:SDP_TEST_OWNER_NAME }
        $worklog = New-SDPChangeWorklog @worklogParams
        $worklog.GetType().Name | Should -Be 'SDPChangeWorklog'
        $script:createdWorklogId = $worklog.Id
    }

    It 'retrieves worklogs for the change' -Skip:(-not $script:createdChangeId) {
        $worklogs = Get-SDPChangeWorklog -ChangeId $script:createdChangeId
        $worklogs | Should -Not -BeNullOrEmpty
    }

    It 'removes the worklog' -Skip:(-not $script:createdWorklogId) {
        { Remove-SDPChangeWorklog -ChangeId $script:createdChangeId -Id $script:createdWorklogId -Confirm:$false } | Should -Not -Throw
    }
}

Describe 'Change lookup data' -Tag 'Integration' {
    It 'returns change types without error' {
        { Get-SDPChangeType } | Should -Not -Throw
    }

    It 'returns change statuses without error' {
        { Get-SDPChangeStatus } | Should -Not -Throw
    }

    It 'returns change stages without error' {
        { Get-SDPChangeStage } | Should -Not -Throw
    }

    It 'returns CABs without error' {
        { Get-SDPCAB } | Should -Not -Throw
    }

    It 'returns change risks without error' {
        { Get-SDPChangeRisk } | Should -Not -Throw
    }
}
