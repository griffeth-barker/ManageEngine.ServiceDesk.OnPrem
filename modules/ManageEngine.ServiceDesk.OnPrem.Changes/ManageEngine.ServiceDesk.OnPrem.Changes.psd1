@{
    RootModule        = 'ManageEngine.ServiceDesk.OnPrem.Changes.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'a1b2c3d4-e5f6-7890-ab12-cd34ef567890'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker'
    Description       = 'Changes module for the ManageEngine ServiceDesk Plus on-premises PowerShell module family. Provides cmdlets for managing changes, notes, tasks, worklogs, deployment schedules, associations, and change configuration data.'
    PowerShellVersion = '7.0'

    ScriptsToProcess  = @(
        'Classes/001-SDPUtil.ps1'
        'Classes/002-SDPReference.ps1'
        'Classes/003-SDPChange.ps1'
        'Classes/004-SDPChangeNote.ps1'
        'Classes/005-SDPChangeTask.ps1'
        'Classes/006-SDPChangeWorklog.ps1'
        'Classes/007-SDPChangeDeploymentSchedule.ps1'
    )

    RequiredModules   = @(
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Core'; ModuleVersion = '0.2.0' }
    )

    FunctionsToExport = @(
        'Get-SDPChange'
        'New-SDPChange'
        'Set-SDPChange'
        'Remove-SDPChange'
        'Restore-SDPChange'
        'Copy-SDPChange'
        'Close-SDPChange'
        'Invoke-SDPChangePickup'
        'Set-SDPChangeAssignment'
        'Get-SDPChangeNote'
        'New-SDPChangeNote'
        'Set-SDPChangeNote'
        'Remove-SDPChangeNote'
        'Get-SDPChangeTask'
        'New-SDPChangeTask'
        'Set-SDPChangeTask'
        'Remove-SDPChangeTask'
        'Get-SDPChangeWorklog'
        'New-SDPChangeWorklog'
        'Set-SDPChangeWorklog'
        'Remove-SDPChangeWorklog'
        'Get-SDPChangeDeploymentSchedule'
        'New-SDPChangeDeploymentSchedule'
        'Set-SDPChangeDeploymentSchedule'
        'Remove-SDPChangeDeploymentSchedule'
        'Get-SDPChangeAssociation'
        'Add-SDPChangeAssociation'
        'Remove-SDPChangeAssociation'
        'Get-SDPChangeType'
        'New-SDPChangeType'
        'Set-SDPChangeType'
        'Remove-SDPChangeType'
        'Get-SDPChangeReason'
        'New-SDPChangeReason'
        'Set-SDPChangeReason'
        'Remove-SDPChangeReason'
        'Get-SDPChangeStatus'
        'New-SDPChangeStatus'
        'Set-SDPChangeStatus'
        'Remove-SDPChangeStatus'
        'Get-SDPChangeStage'
        'Set-SDPChangeStage'
        'Get-SDPChangeRole'
        'New-SDPChangeRole'
        'Set-SDPChangeRole'
        'Remove-SDPChangeRole'
        'Get-SDPChangeRisk'
        'New-SDPChangeRisk'
        'Set-SDPChangeRisk'
        'Remove-SDPChangeRisk'
        'Get-SDPCAB'
        'New-SDPCAB'
        'Set-SDPCAB'
        'Remove-SDPCAB'
        'Get-SDPChangeClosureCode'
        'New-SDPChangeClosureCode'
        'Set-SDPChangeClosureCode'
        'Remove-SDPChangeClosureCode'
        'Get-SDPChangeClosureRule'
        'Set-SDPChangeClosureRule'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API', 'OnPremises', 'Changes', 'ChangeManagement')
            LicenseUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem/blob/main/LICENSE'
            ProjectUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem'
        }
    }
}
