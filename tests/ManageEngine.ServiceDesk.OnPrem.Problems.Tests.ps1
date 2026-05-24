BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' 'modules' 'ManageEngine.ServiceDesk.OnPrem.Problems'
    Import-Module $modulePath -Force -ErrorAction Stop
}

Describe 'Module structure' {
    It 'exports the expected functions' {
        $exported = (Get-Module 'ManageEngine.ServiceDesk.OnPrem.Problems').ExportedFunctions.Keys | Sort-Object
        $expected = @(
            'Add-SDPProblemAssociation'
            'Add-SDPProblemImpactDetails'
            'Add-SDPProblemRootCause'
            'Add-SDPProblemSymptoms'
            'Add-SDPProblemTaskCommentReply'
            'Add-SDPProblemTaskDependency'
            'Close-SDPProblem'
            'Close-SDPProblemTask'
            'Get-SDPProblem'
            'Get-SDPProblemAssociation'
            'Get-SDPProblemImpactDetails'
            'Get-SDPProblemNote'
            'Get-SDPProblemRootCause'
            'Get-SDPProblemSymptoms'
            'Get-SDPProblemTask'
            'Get-SDPProblemTaskComment'
            'Get-SDPProblemTaskDependency'
            'Get-SDPProblemTaskWorklog'
            'Get-SDPProblemTemplate'
            'Get-SDPProblemWorklog'
            'Invoke-SDPProblemPickup'
            'Invoke-SDPProblemTaskMark'
            'Invoke-SDPProblemTaskTrigger'
            'New-SDPProblem'
            'New-SDPProblemNote'
            'New-SDPProblemTask'
            'New-SDPProblemTaskComment'
            'New-SDPProblemTaskWorklog'
            'New-SDPProblemTemplate'
            'New-SDPProblemWorklog'
            'Remove-SDPProblem'
            'Remove-SDPProblemAssociation'
            'Remove-SDPProblemNote'
            'Remove-SDPProblemTask'
            'Remove-SDPProblemTaskComment'
            'Remove-SDPProblemTaskDependency'
            'Remove-SDPProblemTaskWorklog'
            'Remove-SDPProblemTemplate'
            'Remove-SDPProblemWorklog'
            'Set-SDPProblem'
            'Set-SDPProblemAssignment'
            'Set-SDPProblemImpactDetails'
            'Set-SDPProblemNote'
            'Set-SDPProblemRootCause'
            'Set-SDPProblemSymptoms'
            'Set-SDPProblemTask'
            'Set-SDPProblemTaskAssignment'
            'Set-SDPProblemTaskComment'
            'Set-SDPProblemTaskWorklog'
            'Set-SDPProblemTemplate'
            'Set-SDPProblemWorklog'
        ) | Sort-Object
        $exported | Should -Be $expected
    }
}

Describe 'SDPProblem class' {
    It 'constructs from a minimal data object' {
        $data = [pscustomobject]@{
            id          = '123'
            title       = 'Test problem'
            description = 'A test problem'
            status      = [pscustomobject]@{ id = '1'; name = 'Open' }
        }
        $problem = [SDPProblem]::new($data)
        $problem.Id          | Should -Be '123'
        $problem.Title       | Should -Be 'Test problem'
        $problem.Status      | Should -Not -BeNullOrEmpty
        $problem.Status.Name | Should -Be 'Open'
    }

    It 'handles null reference fields gracefully' {
        $data = [pscustomobject]@{ id = '456'; title = 'Minimal' }
        $problem = [SDPProblem]::new($data)
        $problem.Technician | Should -BeNullOrEmpty
        $problem.Group      | Should -BeNullOrEmpty
        $problem.DueByTime  | Should -BeNullOrEmpty
    }

    It 'parses timestamps correctly' {
        $ms = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
        $data = [pscustomobject]@{
            id           = '789'
            title        = 'Timed'
            created_time = [pscustomobject]@{ value = $ms }
        }
        $problem = [SDPProblem]::new($data)
        $problem.CreatedTime | Should -Not -BeNullOrEmpty
        $problem.CreatedTime | Should -BeOfType [datetime]
    }
}

Describe 'SDPProblemNote class' {
    It 'constructs with parent problem ID' {
        $data = [pscustomobject]@{
            id                = '1'
            description       = 'Test note'
            show_to_requester = $true
        }
        $note = [SDPProblemNote]::new('123', $data)
        $note.ProblemId       | Should -Be '123'
        $note.Id              | Should -Be '1'
        $note.ShowToRequester | Should -Be $true
    }
}

Describe 'SDPProblemTask class' {
    It 'constructs with parent problem ID' {
        $data = [pscustomobject]@{
            id                    = '1'
            title                 = 'Investigate logs'
            description           = 'Review system logs'
            percentage_completion = 0
        }
        $task = [SDPProblemTask]::new('123', $data)
        $task.ProblemId            | Should -Be '123'
        $task.Title                | Should -Be 'Investigate logs'
        $task.PercentageCompletion | Should -Be 0
    }
}

Describe 'SDPProblemWorklog class' {
    It 'constructs at problem level' {
        $data = [pscustomobject]@{
            id          = '1'
            description = 'Performed work'
            include_nonoperational_hours = $false
        }
        $log = [SDPProblemWorklog]::new('123', $data)
        $log.ProblemId | Should -Be '123'
        $log.TaskId    | Should -BeNullOrEmpty
        $log.Id        | Should -Be '1'
    }

    It 'constructs at task level' {
        $data = [pscustomobject]@{
            id          = '2'
            description = 'Task-level work'
            include_nonoperational_hours = $true
        }
        $log = [SDPProblemWorklog]::new('123', '456', $data)
        $log.ProblemId                  | Should -Be '123'
        $log.TaskId                     | Should -Be '456'
        $log.IncludeNonOperationalHours | Should -Be $true
    }
}

Describe 'New-SDPProblem parameter validation' {
    It 'Title is mandatory' {
        $param = (Get-Command New-SDPProblem).Parameters['Title']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Set-SDPProblem parameter validation' {
    It 'Id is mandatory' {
        $param = (Get-Command Set-SDPProblem).Parameters['Id']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Close-SDPProblem parameter validation' {
    It 'Id is mandatory' {
        $param = (Get-Command Close-SDPProblem).Parameters['Id']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Add-SDPProblemAssociation parameter validation' {
    It 'rejects an invalid Type value' {
        { Add-SDPProblemAssociation -ProblemId '1' -Type 'InvalidType' -AssociatedId '2' } | Should -Throw
    }

    It 'Type ValidateSet contains Incident and Change' {
        $cmd = Get-Command Add-SDPProblemAssociation
        $validateSet = $cmd.Parameters['Type'].Attributes | Where-Object { $_ -is [ValidateSet] }
        $validateSet.ValidValues | Should -Contain 'Incident'
        $validateSet.ValidValues | Should -Contain 'Change'
    }
}

Describe 'Get-SDPProblemAssociation parameter validation' {
    It 'rejects an invalid Type value' {
        { Get-SDPProblemAssociation -ProblemId '1' -Type 'InvalidType' } | Should -Throw
    }
}

Describe 'Remove-SDPProblem has high confirm impact' {
    It 'ConfirmImpact is High' {
        $cmd = Get-Command Remove-SDPProblem
        $cmdletBinding = $cmd.ScriptBlock.Attributes | Where-Object { $_ -is [CmdletBinding] }
        $cmdletBinding.ConfirmImpact | Should -Be 'High'
    }
}
