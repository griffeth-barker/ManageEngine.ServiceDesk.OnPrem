#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

BeforeAll {
    $moduleName     = 'ServiceDesk.OnPrem.Requests'
    $repoRoot       = Split-Path $PSScriptRoot -Parent
    $manifestPath   = Join-Path $repoRoot $moduleName "$moduleName.psd1"

    Import-Module $manifestPath -Force
}

AfterAll {
    Remove-Module 'ServiceDesk.OnPrem.Requests' -ErrorAction SilentlyContinue
}

Describe 'Module' {
    It 'imports without error' {
        { Import-Module $manifestPath -Force } | Should -Not -Throw
    }

    It 'exports exactly 23 functions' {
        (Get-Command -Module 'ServiceDesk.OnPrem.Requests').Count | Should -Be 23
    }

    It 'all exported functions use approved verbs' {
        $unapproved = Get-Command -Module 'ServiceDesk.OnPrem.Requests' |
            Where-Object { (Get-Verb -Verb $_.Verb) -eq $null }
        $unapproved | Should -BeNullOrEmpty
    }

    It 'all exported functions have a synopsis' {
        $missing = Get-Command -Module 'ServiceDesk.OnPrem.Requests' | Where-Object {
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
        $session = & (Get-Module ServiceDesk.OnPrem.Requests) { $script:SDPSession }
        $session.PortalId | Should -Be 1
    }

    It 'supports -WhatIf' {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        { Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key -WhatIf } | Should -Not -Throw
    }
}

Describe 'Get-SDPRequest' {
    It 'has an Id parameter set' {
        (Get-Command Get-SDPRequest).ParameterSets.Name | Should -Contain 'Id'
    }

    It 'has a List parameter set as default' {
        (Get-Command Get-SDPRequest).DefaultParameterSet | Should -Be 'List'
    }

    It '-Id accepts pipeline input by property name' {
        $attr = (Get-Command Get-SDPRequest).Parameters['Id'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] } |
            Where-Object { $_.ParameterSetName -eq 'Id' }
        $attr.ValueFromPipelineByPropertyName | Should -Be $true
    }

    It 'throws when no session is active' {
        Remove-Module 'ServiceDesk.OnPrem.Requests' -ErrorAction SilentlyContinue
        $repoRoot     = Split-Path $PSScriptRoot -Parent
        $manifestPath = Join-Path $repoRoot 'ServiceDesk.OnPrem.Requests' 'ServiceDesk.OnPrem.Requests.psd1'
        Import-Module $manifestPath -Force
        { Get-SDPRequest -Id '1' } | Should -Throw
    }
}

Describe 'Remove-* functions' {
    It 'Remove-SDPRequest has ConfirmImpact High' {
        $attr = (Get-Command Remove-SDPRequest).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
        $attr.ConfirmImpact | Should -Be 'High'
    }

    It 'Remove-SDPRequestNote has ConfirmImpact High' {
        $attr = (Get-Command Remove-SDPRequestNote).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
        $attr.ConfirmImpact | Should -Be 'High'
    }

    It 'Remove-SDPRequestTask has ConfirmImpact High' {
        $attr = (Get-Command Remove-SDPRequestTask).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
        $attr.ConfirmImpact | Should -Be 'High'
    }

    It 'Remove-SDPRequestWorklog has ConfirmImpact High' {
        $attr = (Get-Command Remove-SDPRequestWorklog).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
        $attr.ConfirmImpact | Should -Be 'High'
    }

    It 'Deny-SDPApproval has ConfirmImpact High' {
        $attr = (Get-Command Deny-SDPApproval).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }
        $attr.ConfirmImpact | Should -Be 'High'
    }
}

Describe 'Write functions support -WhatIf' {
    BeforeAll {
        $key = ConvertTo-SecureString 'test' -AsPlainText -Force
        Connect-SDPService -BaseUri 'https://sdp.local' -TechnicianKey $key -WhatIf
    }

    It 'New-SDPRequest supports -WhatIf without throwing' {
        { New-SDPRequest -Subject 'Test' -WhatIf } | Should -Not -Throw
    }

    It 'Set-SDPRequest supports -WhatIf without throwing' {
        { Set-SDPRequest -Id '1' -Subject 'Updated' -WhatIf } | Should -Not -Throw
    }

    It 'Remove-SDPRequest supports -WhatIf without throwing' {
        { Remove-SDPRequest -Id '1' -WhatIf } | Should -Not -Throw
    }

    It 'New-SDPRequestNote supports -WhatIf without throwing' {
        { New-SDPRequestNote -RequestId '1' -Description 'Test note' -WhatIf } | Should -Not -Throw
    }

    It 'New-SDPRequestResolution supports -WhatIf without throwing' {
        { New-SDPRequestResolution -RequestId '1' -Content 'Test resolution' -WhatIf } | Should -Not -Throw
    }

    It 'Approve-SDPApproval supports -WhatIf without throwing' {
        { Approve-SDPApproval -RequestId '1' -LevelNumber 1 -ApprovalId '1' -WhatIf } | Should -Not -Throw
    }

    It 'Deny-SDPApproval supports -WhatIf without throwing' {
        { Deny-SDPApproval -RequestId '1' -LevelNumber 1 -ApprovalId '1' -WhatIf } | Should -Not -Throw
    }
}
