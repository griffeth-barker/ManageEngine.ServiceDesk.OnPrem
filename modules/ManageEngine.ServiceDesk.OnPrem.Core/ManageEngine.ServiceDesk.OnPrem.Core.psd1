@{
    RootModule        = 'ManageEngine.ServiceDesk.OnPrem.Core.psm1'
    ModuleVersion     = '0.2.0'
    GUID              = '9f8e7d6c-5b4a-4392-8180-7f6e5d4c3b2a'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker'
    Description       = 'Core module for the ManageEngine ServiceDesk Plus on-premises PowerShell module family. Provides authentication, session management, and the shared HTTP transport used by all sub-modules.'
    PowerShellVersion = '7.0'

    ScriptsToProcess  = @('Classes/001-SDPConnection.ps1')

    FunctionsToExport = @(
        'Connect-SDPService'
        'Disconnect-SDPService'
        'Get-SDPSession'
        'Invoke-SDPRestMethod'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData = @{
        PSData = @{
            Tags       = @('ManageEngine', 'ServiceDeskPlus', 'ITSM', 'REST', 'API', 'OnPremises')
            LicenseUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem/blob/main/LICENSE'
            ProjectUri = 'https://github.com/griffeth-barker/ManageEngine.ServiceDesk.OnPrem'
        }
    }
}
