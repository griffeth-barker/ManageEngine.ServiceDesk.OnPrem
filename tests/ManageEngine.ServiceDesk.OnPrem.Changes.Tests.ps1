BeforeAll {
    $repoRoot        = Split-Path $PSScriptRoot -Parent
    $coreManifest    = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Core'    'ManageEngine.ServiceDesk.OnPrem.Core.psd1'
    $changesManifest = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Changes' 'ManageEngine.ServiceDesk.OnPrem.Changes.psd1'

    Import-Module $coreManifest    -Force -ErrorAction Stop
    Import-Module $changesManifest -Force -ErrorAction Stop
}

Describe 'Module structure' {
    It 'exports the expected functions' {
        $exported = (Get-Module 'ManageEngine.ServiceDesk.OnPrem.Changes').ExportedFunctions.Keys | Sort-Object
        $expected = @(
            'Add-SDPChangeAssociation'
            'Close-SDPChange'
            'Copy-SDPChange'
            'Get-SDPCAB'
            'Get-SDPChange'
            'Get-SDPChangeAssociation'
            'Get-SDPChangeClosureCode'
            'Get-SDPChangeClosureRule'
            'Get-SDPChangeDeploymentSchedule'
            'Get-SDPChangeNote'
            'Get-SDPChangeReason'
            'Get-SDPChangeRole'
            'Get-SDPChangeRisk'
            'Get-SDPChangeStage'
            'Get-SDPChangeStatus'
            'Get-SDPChangeTask'
            'Get-SDPChangeType'
            'Get-SDPChangeWorklog'
            'Invoke-SDPChangePickup'
            'New-SDPCAB'
            'New-SDPChange'
            'New-SDPChangeClosureCode'
            'New-SDPChangeDeploymentSchedule'
            'New-SDPChangeNote'
            'New-SDPChangeReason'
            'New-SDPChangeRole'
            'New-SDPChangeRisk'
            'New-SDPChangeStatus'
            'New-SDPChangeTask'
            'New-SDPChangeType'
            'New-SDPChangeWorklog'
            'Remove-SDPCAB'
            'Remove-SDPChange'
            'Remove-SDPChangeAssociation'
            'Remove-SDPChangeClosureCode'
            'Remove-SDPChangeDeploymentSchedule'
            'Remove-SDPChangeNote'
            'Remove-SDPChangeReason'
            'Remove-SDPChangeRole'
            'Remove-SDPChangeRisk'
            'Remove-SDPChangeStatus'
            'Remove-SDPChangeTask'
            'Remove-SDPChangeType'
            'Remove-SDPChangeWorklog'
            'Restore-SDPChange'
            'Set-SDPCAB'
            'Set-SDPChange'
            'Set-SDPChangeAssignment'
            'Set-SDPChangeClosureCode'
            'Set-SDPChangeClosureRule'
            'Set-SDPChangeDeploymentSchedule'
            'Set-SDPChangeNote'
            'Set-SDPChangeReason'
            'Set-SDPChangeRole'
            'Set-SDPChangeRisk'
            'Set-SDPChangeStage'
            'Set-SDPChangeStatus'
            'Set-SDPChangeTask'
            'Set-SDPChangeType'
            'Set-SDPChangeWorklog'
        ) | Sort-Object
        $exported | Should -Be $expected
    }
}

Describe 'SDPChange class' {
    It 'constructs from a minimal data object' {
        $data = [pscustomobject]@{
            id          = '123'
            title       = 'Test change'
            description = 'A test change'
            status      = [pscustomobject]@{ id = '1'; name = 'Open' }
        }
        $change = [SDPChange]::new($data)
        $change.Id     | Should -Be '123'
        $change.Title  | Should -Be 'Test change'
        $change.Status | Should -Not -BeNullOrEmpty
        $change.Status.Name | Should -Be 'Open'
    }

    It 'handles null reference fields gracefully' {
        $data = [pscustomobject]@{ id = '456'; title = 'Minimal' }
        $change = [SDPChange]::new($data)
        $change.Technician | Should -BeNullOrEmpty
        $change.Group      | Should -BeNullOrEmpty
        $change.Stage      | Should -BeNullOrEmpty
    }
}

Describe 'SDPChangeNote class' {
    It 'constructs with parent change ID' {
        $data = [pscustomobject]@{
            id          = '1'
            description = 'Test note'
            show_to_requester = $true
        }
        $note = [SDPChangeNote]::new('123', $data)
        $note.ChangeId         | Should -Be '123'
        $note.Id               | Should -Be '1'
        $note.ShowToRequester  | Should -Be $true
    }
}

Describe 'SDPChangeTask class' {
    It 'constructs with parent change ID' {
        $data = [pscustomobject]@{
            id                    = '1'
            title                 = 'Backup config'
            description           = 'Back up all configs'
            percentage_completion = 0
        }
        $task = [SDPChangeTask]::new('123', $data)
        $task.ChangeId             | Should -Be '123'
        $task.Title                | Should -Be 'Backup config'
        $task.PercentageCompletion | Should -Be 0
    }
}

Describe 'SDPChangeWorklog class' {
    It 'constructs with parent change ID' {
        $data = [pscustomobject]@{
            id          = '1'
            description = 'Performed work'
            include_nonoperational_hours = $false
        }
        $log = [SDPChangeWorklog]::new('123', $data)
        $log.ChangeId | Should -Be '123'
        $log.Id       | Should -Be '1'
    }
}

Describe 'SDPChangeDeploymentSchedule class' {
    It 'constructs with parent change ID' {
        $data = [pscustomobject]@{
            id          = '1'
            description = 'Maintenance window'
        }
        $sched = [SDPChangeDeploymentSchedule]::new('123', $data)
        $sched.ChangeId    | Should -Be '123'
        $sched.Description | Should -Be 'Maintenance window'
    }
}

Describe 'New-SDPChange parameter validation' {
    It 'Title is mandatory' {
        $param = (Get-Command New-SDPChange).Parameters['Title']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Set-SDPChange parameter validation' {
    It 'Id is mandatory' {
        $param = (Get-Command Set-SDPChange).Parameters['Id']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Close-SDPChange parameter validation' {
    It 'Id is mandatory' {
        $param = (Get-Command Close-SDPChange).Parameters['Id']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-SDPChangeAssociation parameter validation' {
    It 'rejects an invalid Type value' {
        { Get-SDPChangeAssociation -ChangeId '1' -Type 'InvalidType' } | Should -Throw
    }

    It 'Type ValidateSet contains all expected values' {
        $cmd = Get-Command Get-SDPChangeAssociation
        $validateSet = $cmd.Parameters['Type'].Attributes | Where-Object { $_ -is [ValidateSet] }
        $validateSet.ValidValues | Should -Contain 'InitiatedRequest'
        $validateSet.ValidValues | Should -Contain 'InitiatedByRequest'
        $validateSet.ValidValues | Should -Contain 'Problem'
        $validateSet.ValidValues | Should -Contain 'Project'
    }
}
