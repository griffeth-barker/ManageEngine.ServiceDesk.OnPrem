@{
    RootModule        = 'ManageEngine.ServiceDesk.OnPrem.Problems.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'c2d3e4f5-a6b7-8901-cd23-ef45ab678901'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker'
    Description       = 'Problems module for the ManageEngine ServiceDesk Plus on-premises PowerShell module family. Provides cmdlets for managing problems, notes, tasks, worklogs, root cause analysis, impact details, symptoms, associations, and problem templates.'
    PowerShellVersion = '7.0'

    ScriptsToProcess  = @(
        'Classes/001-SDPUtil.ps1'
        'Classes/002-SDPReference.ps1'
        'Classes/003-SDPProblem.ps1'
        'Classes/004-SDPProblemNote.ps1'
        'Classes/005-SDPProblemTask.ps1'
        'Classes/006-SDPProblemWorklog.ps1'
    )

    RequiredModules   = @(
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Core'; ModuleVersion = '0.2.0' }
    )

    FunctionsToExport = @(
        'Get-SDPProblem'
        'New-SDPProblem'
        'Set-SDPProblem'
        'Remove-SDPProblem'
        'Invoke-SDPProblemPickup'
        'Close-SDPProblem'
        'Set-SDPProblemAssignment'
        'Get-SDPProblemNote'
        'New-SDPProblemNote'
        'Set-SDPProblemNote'
        'Remove-SDPProblemNote'
        'Get-SDPProblemTask'
        'New-SDPProblemTask'
        'Set-SDPProblemTask'
        'Remove-SDPProblemTask'
        'Invoke-SDPProblemTaskTrigger'
        'Close-SDPProblemTask'
        'Set-SDPProblemTaskAssignment'
        'Invoke-SDPProblemTaskMark'
        'Add-SDPProblemTaskDependency'
        'Remove-SDPProblemTaskDependency'
        'Get-SDPProblemTaskDependency'
        'Get-SDPProblemTaskComment'
        'New-SDPProblemTaskComment'
        'Set-SDPProblemTaskComment'
        'Remove-SDPProblemTaskComment'
        'Add-SDPProblemTaskCommentReply'
        'Get-SDPProblemWorklog'
        'New-SDPProblemWorklog'
        'Set-SDPProblemWorklog'
        'Remove-SDPProblemWorklog'
        'Get-SDPProblemTaskWorklog'
        'New-SDPProblemTaskWorklog'
        'Set-SDPProblemTaskWorklog'
        'Remove-SDPProblemTaskWorklog'
        'Get-SDPProblemRootCause'
        'Add-SDPProblemRootCause'
        'Set-SDPProblemRootCause'
        'Get-SDPProblemImpactDetails'
        'Add-SDPProblemImpactDetails'
        'Set-SDPProblemImpactDetails'
        'Get-SDPProblemSymptoms'
        'Add-SDPProblemSymptoms'
        'Set-SDPProblemSymptoms'
        'Get-SDPProblemAssociation'
        'Add-SDPProblemAssociation'
        'Remove-SDPProblemAssociation'
        'Get-SDPProblemTemplate'
        'New-SDPProblemTemplate'
        'Set-SDPProblemTemplate'
        'Remove-SDPProblemTemplate'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API', 'OnPremises', 'Problems', 'ProblemManagement')
            LicenseUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem/blob/main/LICENSE'
            ProjectUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem'
        }
    }
}
