@{
    RootModule        = 'ManageEngine.ServiceDesk.OnPrem.psm1'
    ModuleVersion     = '0.5.2'
    GUID              = 'd7f3a290-6b1e-4c58-9d7a-e2f1b3c4d5e6'
    Author            = 'Griffeth Barker (github@griff.systems)'
    CompanyName       = ''
    Copyright         = '(c) 2026 Griffeth Barker'
    Description       = 'Umbrella module for the ManageEngine ServiceDesk Plus on-premises PowerShell module family. Installing this module installs all sub-modules. Import individual sub-modules (e.g. ManageEngine.ServiceDesk.OnPrem.Requests) to load only what you need.'
    PowerShellVersion = '7.0'

    RequiredModules = @(
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Core';     ModuleVersion = '0.2.0' }
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Requests'; ModuleVersion = '0.2.1' }
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Changes';  ModuleVersion = '0.1.0' }
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Admin';    ModuleVersion = '0.1.0' }
        @{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Problems'; ModuleVersion = '0.1.0' }
    )

    FunctionsToExport = @()
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
