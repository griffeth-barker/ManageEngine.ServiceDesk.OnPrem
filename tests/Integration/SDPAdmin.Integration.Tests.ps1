#Requires -Version 7.0
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

<#
    Integration tests for ManageEngine.ServiceDesk.OnPrem.Admin.

    Required environment variables:
        SDP_BASE_URI                    - Base URI of the SDP instance (e.g. https://sdp.corp.local:8080)
        SDP_PORTAL_ID                   - (Optional) Portal ID, defaults to 1

    Required SecretsManagement vault secret:
        ZohoSdpOnPremApiKey             - Technician API key as a SecureString

    Optional environment variables (used to scope read tests to specific records):
        SDP_TEST_SITE_ID                - An existing site ID to use for single-record read tests
        SDP_TEST_DEPARTMENT_ID          - An existing department ID to use for single-record read tests
        SDP_TEST_CATEGORY_ID            - An existing category ID to use for single-record read tests
        SDP_TEST_TECHNICIAN_ID          - An existing technician ID to use for single-record read tests

    Optional environment variables (used by lifecycle tests to satisfy mandatory fields):
        SDP_TEST_ADMIN_LIFECYCLE_REGION_ID   - Region ID to associate with the test site (if required)
        SDP_TEST_ADMIN_LIFECYCLE_SITE_ID     - Site ID to associate with the test department (if required)

    User/technician lifecycle notes:
        The User, OrgUser, and Technician lifecycle tests (New-/Set-/Remove-) are skipped by default
        to avoid accidentally creating or deleting real user accounts. Set
        SDP_TEST_ADMIN_USER_LIFECYCLE=1 to enable them.
#>

BeforeAll {
    $repoRoot      = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $coreManifest  = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Core'  'ManageEngine.ServiceDesk.OnPrem.Core.psd1'
    $adminManifest = Join-Path $repoRoot 'modules' 'ManageEngine.ServiceDesk.OnPrem.Admin' 'ManageEngine.ServiceDesk.OnPrem.Admin.psd1'

    Import-Module $coreManifest  -Force
    Import-Module $adminManifest -Force

    if (-not $env:SDP_BASE_URI) { throw 'SDP_BASE_URI environment variable is required.' }

    $secureKey = Get-Secret -Name 'ZohoSdpOnPremApiKey'
    $portalId  = if ($env:SDP_PORTAL_ID) { [int]$env:SDP_PORTAL_ID } else { 1 }

    $connectParams = @{
        BaseUri       = $env:SDP_BASE_URI
        TechnicianKey = $secureKey
        PortalId      = $portalId
    }
    if ($env:SDP_SKIP_CERTIFICATE_CHECK -eq '1') { $connectParams['SkipCertificateCheck'] = $true }

    Connect-SDPService @connectParams
}

AfterAll {
    Disconnect-SDPService
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Admin' -ErrorAction SilentlyContinue
    Remove-Module 'ManageEngine.ServiceDesk.OnPrem.Core'  -ErrorAction SilentlyContinue
}

# ──────────────────────────────────────────────────────────────────────────────
# Reference data — read-only smoke tests
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Reference data reads' -Tag 'Integration' {
    It 'returns statuses without error' {
        { Get-SDPStatus } | Should -Not -Throw
    }

    It 'returns priorities without error' {
        { Get-SDPPriority } | Should -Not -Throw
    }

    It 'returns urgencies without error' {
        { Get-SDPUrgency } | Should -Not -Throw
    }

    It 'returns impacts without error' {
        { Get-SDPImpact } | Should -Not -Throw
    }

    It 'returns levels without error' {
        { Get-SDPLevel } | Should -Not -Throw
    }

    It 'returns modes without error' {
        { Get-SDPMode } | Should -Not -Throw
    }

    It 'returns the priority matrix without error' {
        { Get-SDPPriorityMatrix } | Should -Not -Throw
    }

    It 'returns the priority matrix override setting without error' {
        { Get-SDPPriorityMatrixOverride } | Should -Not -Throw
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Org structure — list and single-read tests
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Get-SDPSite' -Tag 'Integration' {
    It 'returns a list of sites' {
        $results = Get-SDPSite -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPSite'
    }

    It 'returns a single site by Id' -Skip:(-not $env:SDP_TEST_SITE_ID) {
        $result = Get-SDPSite -Id $env:SDP_TEST_SITE_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_SITE_ID
    }
}

Describe 'Get-SDPDepartment' -Tag 'Integration' {
    It 'returns a list of departments' {
        $results = Get-SDPDepartment -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPDepartment'
    }

    It 'returns a single department by Id' -Skip:(-not $env:SDP_TEST_DEPARTMENT_ID) {
        $result = Get-SDPDepartment -Id $env:SDP_TEST_DEPARTMENT_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_DEPARTMENT_ID
    }
}

Describe 'Get-SDPSupportGroup' -Tag 'Integration' {
    It 'returns a list of support groups' {
        $results = Get-SDPSupportGroup -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPSupportGroup'
    }
}

Describe 'Get-SDPCategory' -Tag 'Integration' {
    It 'returns a list of categories' {
        $results = Get-SDPCategory -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPCategory'
    }

    It 'returns a single category by Id' -Skip:(-not $env:SDP_TEST_CATEGORY_ID) {
        $result = Get-SDPCategory -Id $env:SDP_TEST_CATEGORY_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_CATEGORY_ID
    }
}

Describe 'Get-SDPTechnician' -Tag 'Integration' {
    It 'returns a list of technicians' {
        $results = Get-SDPTechnician -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPTechnician'
    }

    It 'returns a single technician by Id' -Skip:(-not $env:SDP_TEST_TECHNICIAN_ID) {
        $result = Get-SDPTechnician -Id $env:SDP_TEST_TECHNICIAN_ID
        $result | Should -Not -BeNullOrEmpty
        $result.Id | Should -Be $env:SDP_TEST_TECHNICIAN_ID
    }
}

Describe 'Get-SDPUser' -Tag 'Integration' {
    It 'returns a list of users' {
        $results = Get-SDPUser -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPUser'
    }
}

Describe 'Get-SDPOrgUser' -Tag 'Integration' {
    It 'returns a list of org users' {
        $results = Get-SDPOrgUser -PageSize 10
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPOrgUser'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Region lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Region lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdRegionId = $null
        $testName = "Pester-Region-$(Get-Date -Format 'yyyyMMddHHmmss')"

        try {
            $region = New-SDPRegion -Name $testName -Description 'Created by Pester integration test — safe to delete.'
            $script:createdRegionId = $region.Id
        } catch {
            Write-Warning "Region creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdRegionId) {
            try { Remove-SDPRegion -Id $script:createdRegionId -Confirm:$false } catch { }
        }
    }

    It 'creates a new region' {
        $script:createdRegionId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created region by Id' -Skip:(-not $script:createdRegionId) {
        $result = Get-SDPRegion -Id $script:createdRegionId
        $result.Id | Should -Be $script:createdRegionId
        $result.GetType().Name | Should -Be 'SDPRegion'
    }

    It 'updates the region description' -Skip:(-not $script:createdRegionId) {
        $updated = Set-SDPRegion -Id $script:createdRegionId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPRegion'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Site lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Site lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdSiteId = $null
        $testName = "Pester-Site-$(Get-Date -Format 'yyyyMMddHHmmss')"

        $createParams = @{
            Name        = $testName
            Description = 'Created by Pester integration test — safe to delete.'
        }
        if ($env:SDP_TEST_ADMIN_LIFECYCLE_REGION_ID) { $createParams['RegionId'] = $env:SDP_TEST_ADMIN_LIFECYCLE_REGION_ID }

        try {
            $site = New-SDPSite @createParams
            $script:createdSiteId = $site.Id
        } catch {
            Write-Warning "Site creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdSiteId) {
            try { Remove-SDPSite -Id $script:createdSiteId -Confirm:$false } catch { }
        }
    }

    It 'creates a new site' {
        $script:createdSiteId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created site by Id' -Skip:(-not $script:createdSiteId) {
        $result = Get-SDPSite -Id $script:createdSiteId
        $result.Id | Should -Be $script:createdSiteId
        $result.GetType().Name | Should -Be 'SDPSite'
    }

    It 'updates the site description' -Skip:(-not $script:createdSiteId) {
        $updated = Set-SDPSite -Id $script:createdSiteId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPSite'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Department lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Department lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdDeptId = $null
        $testName = "Pester-Dept-$(Get-Date -Format 'yyyyMMddHHmmss')"

        $createParams = @{
            Name        = $testName
            Description = 'Created by Pester integration test — safe to delete.'
        }
        if ($env:SDP_TEST_ADMIN_LIFECYCLE_SITE_ID) { $createParams['SiteId'] = $env:SDP_TEST_ADMIN_LIFECYCLE_SITE_ID }

        try {
            $dept = New-SDPDepartment @createParams
            $script:createdDeptId = $dept.Id
        } catch {
            Write-Warning "Department creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdDeptId) {
            try { Remove-SDPDepartment -Id $script:createdDeptId -Confirm:$false } catch { }
        }
    }

    It 'creates a new department' {
        $script:createdDeptId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created department by Id' -Skip:(-not $script:createdDeptId) {
        $result = Get-SDPDepartment -Id $script:createdDeptId
        $result.Id | Should -Be $script:createdDeptId
        $result.GetType().Name | Should -Be 'SDPDepartment'
    }

    It 'updates the department description' -Skip:(-not $script:createdDeptId) {
        $updated = Set-SDPDepartment -Id $script:createdDeptId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPDepartment'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Category → Subcategory → Item lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Category lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdCategoryId    = $null
        $script:createdSubcategoryId = $null
        $script:createdItemId        = $null
        $stamp = Get-Date -Format 'yyyyMMddHHmmss'

        try {
            $cat = New-SDPCategory -Name "Pester-Cat-$stamp" -Description 'Pester integration test — safe to delete.'
            $script:createdCategoryId = $cat.Id
        } catch {
            Write-Warning "Category creation failed: $_"
        }

        if ($script:createdCategoryId) {
            try {
                $sub = New-SDPSubcategory -Name "Pester-Sub-$stamp" -CategoryId $script:createdCategoryId
                $script:createdSubcategoryId = $sub.Id
            } catch {
                Write-Warning "Subcategory creation failed: $_"
            }
        }

        if ($script:createdSubcategoryId) {
            try {
                $item = New-SDPItem -Name "Pester-Item-$stamp" -SubcategoryId $script:createdSubcategoryId
                $script:createdItemId = $item.Id
            } catch {
                Write-Warning "Item creation failed: $_"
            }
        }
    }

    AfterAll {
        if ($script:createdItemId)        { try { Remove-SDPItem        -Id $script:createdItemId        -Confirm:$false } catch { } }
        if ($script:createdSubcategoryId) { try { Remove-SDPSubcategory -Id $script:createdSubcategoryId -Confirm:$false } catch { } }
        if ($script:createdCategoryId)    { try { Remove-SDPCategory    -Id $script:createdCategoryId    -Confirm:$false } catch { } }
    }

    It 'creates a new category' {
        $script:createdCategoryId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created category by Id' -Skip:(-not $script:createdCategoryId) {
        $result = Get-SDPCategory -Id $script:createdCategoryId
        $result.Id | Should -Be $script:createdCategoryId
        $result.GetType().Name | Should -Be 'SDPCategory'
    }

    It 'updates the category description' -Skip:(-not $script:createdCategoryId) {
        $updated = Set-SDPCategory -Id $script:createdCategoryId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPCategory'
    }

    It 'creates a subcategory under the category' {
        $script:createdSubcategoryId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the subcategory by Id' -Skip:(-not $script:createdSubcategoryId) {
        $result = Get-SDPSubcategory -Id $script:createdSubcategoryId
        $result.Id | Should -Be $script:createdSubcategoryId
        $result.GetType().Name | Should -Be 'SDPSubcategory'
    }

    It 'lists subcategories under the parent category' -Skip:(-not $script:createdCategoryId) {
        $results = Get-SDPSubcategory -CategoryId $script:createdCategoryId
        $results | Should -Not -BeNullOrEmpty
        $results[0].GetType().Name | Should -Be 'SDPSubcategory'
    }

    It 'updates the subcategory description' -Skip:(-not $script:createdSubcategoryId) {
        $updated = Set-SDPSubcategory -Id $script:createdSubcategoryId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPSubcategory'
    }

    It 'creates an item under the subcategory' {
        $script:createdItemId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the item by Id' -Skip:(-not $script:createdItemId) {
        $result = Get-SDPItem -Id $script:createdItemId
        $result.Id | Should -Be $script:createdItemId
        $result.GetType().Name | Should -Be 'SDPItem'
    }

    It 'updates the item description' -Skip:(-not $script:createdItemId) {
        $updated = Set-SDPItem -Id $script:createdItemId -Description 'Updated by Pester.'
        $updated.GetType().Name | Should -Be 'SDPItem'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Announcement lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Announcement lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdAnnouncementId = $null
        $testTitle = "Pester-Announcement-$(Get-Date -Format 'yyyyMMddHHmmss')"

        try {
            $ann = New-SDPAnnouncement -Title $testTitle -Content 'Pester integration test — safe to delete.'
            $script:createdAnnouncementId = $ann.Id
        } catch {
            Write-Warning "Announcement creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdAnnouncementId) {
            try { Remove-SDPAnnouncement -Id $script:createdAnnouncementId -Confirm:$false } catch { }
        }
    }

    It 'creates a new announcement' {
        $script:createdAnnouncementId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created announcement by Id' -Skip:(-not $script:createdAnnouncementId) {
        $result = Get-SDPAnnouncement -Id $script:createdAnnouncementId
        $result.Id | Should -Be $script:createdAnnouncementId
        $result.GetType().Name | Should -Be 'SDPAnnouncement'
    }

    It 'updates the announcement title' -Skip:(-not $script:createdAnnouncementId) {
        $updated = Set-SDPAnnouncement -Id $script:createdAnnouncementId -Title "$testTitle (updated)"
        $updated.GetType().Name | Should -Be 'SDPAnnouncement'
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# Reminder lifecycle
# ──────────────────────────────────────────────────────────────────────────────

Describe 'Reminder lifecycle' -Tag 'Integration' {
    BeforeAll {
        $script:createdReminderId = $null
        $testSummary = "Pester-Reminder-$(Get-Date -Format 'yyyyMMddHHmmss')"

        try {
            $rem = New-SDPReminder -Summary $testSummary -Date (Get-Date).AddDays(7)
            $script:createdReminderId = $rem.Id
        } catch {
            Write-Warning "Reminder creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdReminderId) {
            try { Remove-SDPReminder -Id $script:createdReminderId -Confirm:$false } catch { }
        }
    }

    It 'creates a new reminder' {
        $script:createdReminderId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created reminder by Id' -Skip:(-not $script:createdReminderId) {
        $result = Get-SDPReminder -Id $script:createdReminderId
        $result.Id | Should -Be $script:createdReminderId
        $result.GetType().Name | Should -Be 'SDPReminder'
    }

    It 'updates the reminder summary' -Skip:(-not $script:createdReminderId) {
        $updated = Set-SDPReminder -Id $script:createdReminderId -Summary "$testSummary (updated)"
        $updated.GetType().Name | Should -Be 'SDPReminder'
    }

    It 'closes the reminder' -Skip:(-not $script:createdReminderId) {
        { Close-SDPReminder -Id $script:createdReminderId -Confirm:$false } | Should -Not -Throw
    }

    It 're-opens the reminder' -Skip:(-not $script:createdReminderId) {
        { Open-SDPReminder -Id $script:createdReminderId -Confirm:$false } | Should -Not -Throw
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# User / OrgUser / Technician lifecycle  (opt-in — set SDP_TEST_ADMIN_USER_LIFECYCLE=1)
# ──────────────────────────────────────────────────────────────────────────────

Describe 'OrgUser lifecycle' -Tag 'Integration' -Skip:($env:SDP_TEST_ADMIN_USER_LIFECYCLE -ne '1') {
    BeforeAll {
        $script:createdOrgUserId = $null
        $stamp    = Get-Date -Format 'yyyyMMddHHmmss'
        $testName = "Pester OrgUser $stamp"

        try {
            $ou = New-SDPOrgUser -Name $testName -LoginName "pester_ou_$stamp" -EmailId "pester_ou_$stamp@example.invalid"
            $script:createdOrgUserId = $ou.Id
        } catch {
            Write-Warning "OrgUser creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdOrgUserId) {
            try { Remove-SDPOrgUser -Id $script:createdOrgUserId -Confirm:$false } catch { }
        }
    }

    It 'creates a new org user' {
        $script:createdOrgUserId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created org user by Id' -Skip:(-not $script:createdOrgUserId) {
        $result = Get-SDPOrgUser -Id $script:createdOrgUserId
        $result.Id | Should -Be $script:createdOrgUserId
        $result.GetType().Name | Should -Be 'SDPOrgUser'
    }

    It 'updates the org user job title' -Skip:(-not $script:createdOrgUserId) {
        $updated = Set-SDPOrgUser -Id $script:createdOrgUserId -JobTitle 'Pester Test Account'
        $updated.GetType().Name | Should -Be 'SDPOrgUser'
    }
}

Describe 'User lifecycle' -Tag 'Integration' -Skip:($env:SDP_TEST_ADMIN_USER_LIFECYCLE -ne '1') {
    BeforeAll {
        $script:createdUserId = $null
        $stamp    = Get-Date -Format 'yyyyMMddHHmmss'
        $testName = "Pester User $stamp"

        try {
            $u = New-SDPUser -Name $testName -LoginName "pester_u_$stamp" -EmailId "pester_u_$stamp@example.invalid"
            $script:createdUserId = $u.Id
        } catch {
            Write-Warning "User creation failed: $_"
        }
    }

    AfterAll {
        if ($script:createdUserId) {
            try { Remove-SDPUser -Id $script:createdUserId -Confirm:$false } catch { }
        }
    }

    It 'creates a new user' {
        $script:createdUserId | Should -Not -BeNullOrEmpty
    }

    It 'retrieves the created user by Id' -Skip:(-not $script:createdUserId) {
        $result = Get-SDPUser -Id $script:createdUserId
        $result.Id | Should -Be $script:createdUserId
        $result.GetType().Name | Should -Be 'SDPUser'
    }

    It 'updates the user job title' -Skip:(-not $script:createdUserId) {
        $updated = Set-SDPUser -Id $script:createdUserId -JobTitle 'Pester Test Account'
        $updated.GetType().Name | Should -Be 'SDPUser'
    }
}
