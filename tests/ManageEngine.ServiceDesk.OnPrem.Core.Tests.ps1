#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

BeforeAll {
    $moduleName   = 'ManageEngine.ServiceDesk.OnPrem.Core'
    $repoRoot     = Split-Path $PSScriptRoot -Parent
    $manifestPath = Join-Path $repoRoot 'modules' $moduleName "$moduleName.psd1"

    Import-Module $manifestPath -Force
}

AfterAll {
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Core' -ErrorAction SilentlyContinue
}

Describe 'Module' {
    It 'imports without error' {
        { Import-Module $manifestPath -Force } | Should -Not -Throw
    }

    It 'exports exactly 4 functions' {
        (Get-Command -Module 'ManageEngine.ServiceDesk.OnPrem.Core').Count | Should -Be 4
    }

    It 'all exported functions use approved verbs' {
        $unapproved = Get-Command -Module 'ManageEngine.ServiceDesk.OnPrem.Core' |
            Where-Object { (Get-Verb -Verb $_.Verb) -eq $null }
        $unapproved | Should -BeNullOrEmpty
    }

    It 'all exported functions have a synopsis' {
        $missing = Get-Command -Module 'ManageEngine.ServiceDesk.OnPrem.Core' | Where-Object {
            -not (Get-Help $_.Name).Synopsis
        }
        $missing | Should -BeNullOrEmpty
    }
}

Describe 'Connect-SDPService' {
    It 'has a mandatory BaseUri parameter' {
        $param = (Get-Command Connect-SDPService).Parameters['BaseUri']
        $param.Attributes.Mandatory | Should -Be $true
    }

    It 'has a mandatory TechnicianKey parameter' {
        $param = (Get-Command Connect-SDPService).Parameters['TechnicianKey']
        $param.Attributes.Mandatory | Should -Be $true
    }

    It 'defaults PortalId to 1 when not specified' {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key
        $session = Get-SDPSession
        $session.PortalId | Should -Be 1
    }

    It 'supports -WhatIf' {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        { Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key -WhatIf } | Should -Not -Throw
    }
}

Describe 'Get-SDPSession' {
    It 'throws when no session is active' {
        Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Core' -ErrorAction SilentlyContinue
        Import-Module $manifestPath -Force
        { Get-SDPSession } | Should -Throw
    }

    It 'returns the active session after Connect-SDPService' {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key
        $session = Get-SDPSession
        $session | Should -Not -BeNullOrEmpty
        $session.ApiBaseUri | Should -Be 'https://sdp.local/api/v3'
    }
}

Describe 'Disconnect-SDPService' {
    It 'clears the active session' {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key
        Disconnect-SDPService
        { Get-SDPSession } | Should -Throw
    }

    It 'supports -WhatIf' {
        { Disconnect-SDPService -WhatIf } | Should -Not -Throw
    }
}
