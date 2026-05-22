@{
    RootModule        = 'ManageEngine.ServiceDesk.OnPrem.Requests.psm1'
    ModuleVersion     = '0.2.0'
    GUID              = '3c4d5e6f-7a8b-4910-a2b3-c4d5e6f7a8b9'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker'
    Description       = 'Requests module for the ManageEngine ServiceDesk Plus on-premises PowerShell module family. Provides cmdlets for managing requests, notes, tasks, worklogs, resolutions, and approvals.'
    PowerShellVersion = '7.0'

    ScriptsToProcess  = @(
        'Classes/001-SDPUtil.ps1'
        'Classes/002-SDPReference.ps1'
        'Classes/003-SDPRequest.ps1'
        'Classes/004-SDPRequestNote.ps1'
        'Classes/005-SDPRequestTask.ps1'
        'Classes/006-SDPRequestWorklog.ps1'
        'Classes/007-SDPRequestResolution.ps1'
    )

    RequiredModules   = @(
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Core'; ModuleVersion = '0.2.0' }
    )

    FunctionsToExport = @(
        'Get-SDPRequest'
        'New-SDPRequest'
        'Set-SDPRequest'
        'Get-SDPRequestNote'
        'New-SDPRequestNote'
        'Set-SDPRequestNote'
        'Remove-SDPRequestNote'
        'Get-SDPRequestTask'
        'New-SDPRequestTask'
        'Set-SDPRequestTask'
        'Remove-SDPRequestTask'
        'Get-SDPRequestWorklog'
        'New-SDPRequestWorklog'
        'Set-SDPRequestWorklog'
        'Remove-SDPRequestWorklog'
        'Get-SDPRequestResolution'
        'New-SDPRequestResolution'
        'Get-SDPApproval'
        'Approve-SDPApproval'
        'Deny-SDPApproval'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API', 'OnPremises', 'Requests')
            LicenseUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem/blob/main/LICENSE'
            ProjectUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem'
        }
    }
}
