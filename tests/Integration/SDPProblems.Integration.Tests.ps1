#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

<#
    Integration tests for ManageEngine.ServiceDesk.OnPrem.Problems.

    Required environment variables:
        SDP_BASE_URI               - Base URI of the SDP instance (e.g. https://sdp.corp.local:8080)
        SDP_PORTAL_ID              - (Optional) Portal ID, defaults to 1

    Required SecretsManagement vault secret:
        ZohoSdpOnPremApiKey        - Technician API key as a SecureString

    Optional environment variables (used to scope tests to specific records):
        SDP_TEST_PROBLEM_ID        - An existing problem ID to use for read tests

    Optional environment variables (used by lifecycle tests to satisfy mandatory fields):
        SDP_TEST_PRIORITY_NAME     - Priority name required by the SDP instance (e.g. 'High')
        SDP_TEST_TECHNICIAN_NAME   - Technician name required by the SDP instance (e.g. 'Bob Jones')
        SDP_TEST_OWNER_NAME        - Technician name for worklog owner, if mandatory on the instance
#>

BeforeAll {
    $repoRoot         = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $coreManifest     = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Core'     'ManageEngine.ServiceDesk.OnPrem.Core.psd1'
    $problemsManifest = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Problems' 'ManageEngine.ServiceDesk.OnPrem.Problems.psd1'

    Import-Module $coreManifest     -Force
    Import-Module $problemsManifest -Force

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

Describe 'Get-SDPProblem' -Tag 'Integration' {
    It 'returns a list of problems' {
        $problems = Get-SDPProblem -PageSize 5
        $problems | Should -Not -BeNullOrEmpty
    }

    It 'returns a single problem by ID' -Skip:(-not $env:SDP_TEST_PROBLEM_ID) {
        $problem = Get-SDPProblem -Id $env:SDP_TEST_PROBLEM_ID
        $problem       | Should -Not -BeNullOrEmpty
        $problem.Id    | Should -Be $env:SDP_TEST_PROBLEM_ID
        $problem.Title | Should -Not -BeNullOrEmpty
    }
}

Describe 'Problem lifecycle' -Tag 'Integration' {
    BeforeAll {
        $title        = "Integration-Test-Problem-$(Get-Date -Format 'yyyyMMddHHmmss')"
        $priorityName = if ($env:SDP_TEST_PRIORITY_NAME) { $env:SDP_TEST_PRIORITY_NAME } else { $null }

        $newParams = @{ Title = $title }
        if ($priorityName) { $newParams['PriorityName'] = $priorityName }

        $script:problem = New-SDPProblem @newParams
    }

    It 'creates a problem' {
        $script:problem       | Should -Not -BeNullOrEmpty
        $script:problem.Id    | Should -Not -BeNullOrEmpty
        $script:problem.Title | Should -Be $title
    }

    It 'updates the problem' {
        $updated = Set-SDPProblem -Id $script:problem.Id -Description 'Integration test update'
        $updated.Description | Should -Be 'Integration test update'
    }

    It 'adds and retrieves a note' {
        $note = New-SDPProblemNote -ProblemId $script:problem.Id -Description 'Integration test note'
        $note | Should -Not -BeNullOrEmpty

        $notes = Get-SDPProblemNote -ProblemId $script:problem.Id
        $notes | Where-Object { $_.Id -eq $note.Id } | Should -Not -BeNullOrEmpty
    }

    It 'adds a task and retrieves it' {
        $task = New-SDPProblemTask -ProblemId $script:problem.Id -Title 'Integration test task'
        $task | Should -Not -BeNullOrEmpty

        $fetched = Get-SDPProblemTask -ProblemId $script:problem.Id -Id $task.Id
        $fetched.Title | Should -Be 'Integration test task'
    }

    It 'adds a worklog' {
        $ownerName = $env:SDP_TEST_OWNER_NAME
        $wlParams  = @{
            ProblemId   = $script:problem.Id
            Description = 'Integration test worklog'
            StartTime   = (Get-Date).AddHours(-1)
            EndTime     = Get-Date
        }
        if ($ownerName) { $wlParams['OwnerName'] = $ownerName }

        $wl = New-SDPProblemWorklog @wlParams
        $wl | Should -Not -BeNullOrEmpty
    }

    AfterAll {
        if ($script:problem) {
            Remove-SDPProblem -Id $script:problem.Id -Confirm:$false
        }
    }
}
