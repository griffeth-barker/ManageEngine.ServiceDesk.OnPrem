BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' 'modules' 'ManageEngine.ServiceDesk.OnPrem.Admin'
    Import-Module $modulePath -Force -ErrorAction Stop
}

Describe 'Module structure' {
    It 'exports the expected functions' {
        $exported = (Get-Module 'ManageEngine.ServiceDesk.OnPrem.Admin').ExportedFunctions.Keys | Sort-Object
        $expected = @(
            'Close-SDPReminder'
            'Convert-SDPTechnicianToUser'
            'Convert-SDPUserToTechnician'
            'Get-SDPAnnouncement'
            'Get-SDPCategory'
            'Get-SDPDepartment'
            'Get-SDPImpact'
            'Get-SDPItem'
            'Get-SDPLevel'
            'Get-SDPMode'
            'Get-SDPOrgUser'
            'Get-SDPPriority'
            'Get-SDPPriorityMatrix'
            'Get-SDPPriorityMatrixOverride'
            'Get-SDPRegion'
            'Get-SDPReminder'
            'Get-SDPSite'
            'Get-SDPStatus'
            'Get-SDPSubcategory'
            'Get-SDPSupportGroup'
            'Get-SDPTechnician'
            'Get-SDPUrgency'
            'Get-SDPUser'
            'New-SDPAnnouncement'
            'New-SDPCategory'
            'New-SDPDepartment'
            'New-SDPImpact'
            'New-SDPItem'
            'New-SDPLevel'
            'New-SDPMode'
            'New-SDPOrgUser'
            'New-SDPPriority'
            'New-SDPPriorityMatrix'
            'New-SDPRegion'
            'New-SDPReminder'
            'New-SDPSite'
            'New-SDPStatus'
            'New-SDPSubcategory'
            'New-SDPSupportGroup'
            'New-SDPTechnician'
            'New-SDPUrgency'
            'New-SDPUser'
            'Open-SDPReminder'
            'Remove-SDPAnnouncement'
            'Remove-SDPCategory'
            'Remove-SDPDepartment'
            'Remove-SDPImpact'
            'Remove-SDPItem'
            'Remove-SDPLevel'
            'Remove-SDPMode'
            'Remove-SDPOrgUser'
            'Remove-SDPPriority'
            'Remove-SDPPriorityMatrix'
            'Remove-SDPRegion'
            'Remove-SDPReminder'
            'Remove-SDPSite'
            'Remove-SDPStatus'
            'Remove-SDPSubcategory'
            'Remove-SDPSupportGroup'
            'Remove-SDPTechnician'
            'Remove-SDPUrgency'
            'Remove-SDPUser'
            'Set-SDPAnnouncement'
            'Set-SDPCategory'
            'Set-SDPDepartment'
            'Set-SDPImpact'
            'Set-SDPItem'
            'Set-SDPLevel'
            'Set-SDPMode'
            'Set-SDPOrgUser'
            'Set-SDPPriority'
            'Set-SDPPriorityMatrix'
            'Set-SDPPriorityMatrixOverride'
            'Set-SDPRegion'
            'Set-SDPReminder'
            'Set-SDPSite'
            'Set-SDPStatus'
            'Set-SDPSubcategory'
            'Set-SDPSupportGroup'
            'Set-SDPTechnician'
            'Set-SDPUrgency'
            'Set-SDPUser'
        ) | Sort-Object
        $exported | Should -Be $expected
    }
}

Describe 'SDPOrgUser class' {
    It 'constructs from a minimal data object' {
        $data = [pscustomobject]@{
            id         = '10'
            name       = 'Jane Smith'
            email_id   = 'jane@example.com'
            department = [pscustomobject]@{ id = '2'; name = 'Engineering' }
        }
        $user = [SDPOrgUser]::new($data)
        $user.Id         | Should -Be '10'
        $user.Name       | Should -Be 'Jane Smith'
        $user.EmailId    | Should -Be 'jane@example.com'
        $user.Department | Should -Not -BeNullOrEmpty
        $user.Department.Name | Should -Be 'Engineering'
    }

    It 'handles null optional fields gracefully' {
        $data = [pscustomobject]@{ id = '1'; name = 'Minimal' }
        $user = [SDPOrgUser]::new($data)
        $user.Department  | Should -BeNullOrEmpty
        $user.ReportingTo | Should -BeNullOrEmpty
    }
}

Describe 'SDPUser class' {
    It 'constructs from a data object with technician flag' {
        $data = [pscustomobject]@{
            id             = '5'
            name           = 'Bob Jones'
            email_id       = 'bob@example.com'
            is_technician  = $true
            is_vipuser     = $false
        }
        $user = [SDPUser]::new($data)
        $user.Id           | Should -Be '5'
        $user.IsTechnician | Should -Be $true
        $user.IsVipUser    | Should -Be $false
    }
}

Describe 'SDPTechnician class' {
    It 'constructs from a minimal data object' {
        $data = [pscustomobject]@{
            id        = '7'
            name      = 'Alice Tech'
            email_id  = 'alice@example.com'
            is_online = $true
        }
        $tech = [SDPTechnician]::new($data)
        $tech.Id       | Should -Be '7'
        $tech.Name     | Should -Be 'Alice Tech'
        $tech.IsOnline | Should -Be $true
    }
}

Describe 'SDPSite class' {
    It 'constructs with region reference' {
        $data = [pscustomobject]@{
            id     = '3'
            name   = 'Austin HQ'
            city   = 'Austin'
            state  = 'TX'
            region = [pscustomobject]@{ id = '1'; name = 'North America' }
        }
        $site = [SDPSite]::new($data)
        $site.Id          | Should -Be '3'
        $site.City        | Should -Be 'Austin'
        $site.Region      | Should -Not -BeNullOrEmpty
        $site.Region.Name | Should -Be 'North America'
    }

    It 'handles null region gracefully' {
        $data = [pscustomobject]@{ id = '4'; name = 'Remote' }
        $site = [SDPSite]::new($data)
        $site.Region | Should -BeNullOrEmpty
    }
}

Describe 'SDPRegion class' {
    It 'constructs from a data object' {
        $data = [pscustomobject]@{ id = '1'; name = 'North America'; description = 'US and Canada' }
        $region = [SDPRegion]::new($data)
        $region.Id          | Should -Be '1'
        $region.Name        | Should -Be 'North America'
        $region.Description | Should -Be 'US and Canada'
    }
}

Describe 'SDPDepartment class' {
    It 'constructs with department head reference' {
        $data = [pscustomobject]@{
            id              = '2'
            name            = 'Engineering'
            department_head = [pscustomobject]@{ id = '5'; name = 'admin' }
        }
        $dept = [SDPDepartment]::new($data)
        $dept.Id                   | Should -Be '2'
        $dept.DepartmentHead       | Should -Not -BeNullOrEmpty
        $dept.DepartmentHead.Name  | Should -Be 'admin'
    }
}

Describe 'SDPSupportGroup class' {
    It 'constructs from a minimal data object' {
        $data = [pscustomobject]@{ id = '7'; name = 'Helpdesk'; description = 'Level 1 support' }
        $group = [SDPSupportGroup]::new($data)
        $group.Id          | Should -Be '7'
        $group.Description | Should -Be 'Level 1 support'
        $group.Site        | Should -BeNullOrEmpty
    }
}

Describe 'SDPCategory class' {
    It 'constructs from a data object' {
        $data = [pscustomobject]@{ id = '10'; name = 'Hardware'; description = 'Hardware issues' }
        $cat = [SDPCategory]::new($data)
        $cat.Id   | Should -Be '10'
        $cat.Name | Should -Be 'Hardware'
    }
}

Describe 'SDPSubcategory class' {
    It 'constructs with parent category reference' {
        $data = [pscustomobject]@{
            id       = '50'
            name     = 'Laptop'
            category = [pscustomobject]@{ id = '10'; name = 'Hardware' }
        }
        $sub = [SDPSubcategory]::new($data)
        $sub.Id            | Should -Be '50'
        $sub.Category      | Should -Not -BeNullOrEmpty
        $sub.Category.Name | Should -Be 'Hardware'
    }
}

Describe 'SDPItem class' {
    It 'constructs with subcategory reference' {
        $data = [pscustomobject]@{
            id          = '100'
            name        = 'Dell Latitude'
            subcategory = [pscustomobject]@{ id = '50'; name = 'Laptop' }
        }
        $item = [SDPItem]::new($data)
        $item.Id               | Should -Be '100'
        $item.Subcategory      | Should -Not -BeNullOrEmpty
        $item.Subcategory.Name | Should -Be 'Laptop'
    }
}

Describe 'SDPAnnouncement class' {
    It 'constructs from a data object with timestamps' {
        $data = [pscustomobject]@{
            id        = '5'
            title     = 'Maintenance Tonight'
            content   = 'Servers offline 10pm-2am'
            is_public = $true
            from_date = [pscustomobject]@{ value = '1700000000000' }
            to_date   = $null
        }
        $ann = [SDPAnnouncement]::new($data)
        $ann.Id       | Should -Be '5'
        $ann.Title    | Should -Be 'Maintenance Tonight'
        $ann.IsPublic | Should -Be $true
        $ann.FromDate | Should -Not -BeNullOrEmpty
        $ann.ToDate   | Should -BeNullOrEmpty
    }
}

Describe 'SDPReminder class' {
    It 'constructs from a data object' {
        $data = [pscustomobject]@{
            id      = '10'
            summary = 'Follow up on ticket 25'
            status  = 'Open'
            date    = [pscustomobject]@{ value = '1700000000000' }
        }
        $rem = [SDPReminder]::new($data)
        $rem.Id      | Should -Be '10'
        $rem.Summary | Should -Be 'Follow up on ticket 25'
        $rem.Status  | Should -Be 'Open'
        $rem.Date    | Should -Not -BeNullOrEmpty
    }
}

Describe 'New-SDPOrgUser parameter validation' {
    It 'Name is mandatory' {
        $param = (Get-Command New-SDPOrgUser).Parameters['Name']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'New-SDPUser parameter validation' {
    It 'Name is mandatory' {
        $param = (Get-Command New-SDPUser).Parameters['Name']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'New-SDPTechnician parameter validation' {
    It 'Name is mandatory' {
        $param = (Get-Command New-SDPTechnician).Parameters['Name']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'New-SDPSubcategory parameter validation' {
    It 'CategoryId is mandatory' {
        $param = (Get-Command New-SDPSubcategory).Parameters['CategoryId']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'New-SDPItem parameter validation' {
    It 'SubcategoryId is mandatory' {
        $param = (Get-Command New-SDPItem).Parameters['SubcategoryId']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-SDPSubcategory parameter validation' {
    It 'CategoryId is mandatory in List parameter set' {
        $param = (Get-Command Get-SDPSubcategory).Parameters['CategoryId']
        $mandAttr = $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory })
        $mandAttr | Should -Not -BeNullOrEmpty
    }
}

Describe 'Remove-SDPDepartment parameter validation' {
    It 'Id accepts array of strings' {
        $param = (Get-Command Remove-SDPDepartment).Parameters['Id']
        $param.ParameterType | Should -Be ([string[]])
    }
}

Describe 'Convert-SDPTechnicianToUser parameter validation' {
    It 'Id accepts array of strings' {
        $param = (Get-Command Convert-SDPTechnicianToUser).Parameters['Id']
        $param.ParameterType | Should -Be ([string[]])
    }
}

Describe 'Set-SDPPriorityMatrixOverride parameter validation' {
    It 'AllowOverride is mandatory' {
        $param = (Get-Command Set-SDPPriorityMatrixOverride).Parameters['AllowOverride']
        $param.Attributes.Where({ $_ -is [Parameter] -and $_.Mandatory }) | Should -Not -BeNullOrEmpty
    }
}
