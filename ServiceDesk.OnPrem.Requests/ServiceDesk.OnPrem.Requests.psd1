@{
    RootModule        = 'ServiceDesk.OnPrem.Requests.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'e7c6d5f4-a3b2-4c1d-8e9f-0a1b2c3d4e5f'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker. All rights reserved.'
    Description       = 'PowerShell module for the ManageEngine ServiceDesk Plus on-premises REST API v3 — Requests module.'
    PowerShellVersion = '7.0'

    FunctionsToExport = @(
        'Connect-SDPService'
        'Disconnect-SDPService'
        'Get-SDPRequest'
        'New-SDPRequest'
        'Set-SDPRequest'
        'Remove-SDPRequest'
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
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API', 'OnPremises')
            LicenseUri = 'https://github.com/griffeth-barker/ServiceDesk.OnPrem.Requests/blob/main/LICENSE'
            ProjectUri = 'https://github.com/griffeth-barker/ServiceDesk.OnPrem.Requests'
        }
    }
}
