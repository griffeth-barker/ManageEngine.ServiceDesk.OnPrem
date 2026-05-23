#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('All', 'Docs', 'Test', 'IntegrationTest', 'Package')]
    [string]$Task = 'All',

    [Parameter()]
    [ValidateSet('Core', 'Requests', 'Changes', 'All')]
    [string]$Module = 'All',

    [Parameter()]
    [switch]$SkipCertificateCheck
)

$ErrorActionPreference = 'Stop'

$repoRoot   = $PSScriptRoot
$modulesDir = Join-Path $repoRoot 'modules'
$testsDir   = Join-Path $repoRoot 'tests'
$distDir    = Join-Path $repoRoot 'dist'

$allModules = @(
    'ManageEngine.ServiceDesk.OnPrem.Core'
    'ManageEngine.ServiceDesk.OnPrem.Requests'
    'ManageEngine.ServiceDesk.OnPrem.Changes'
    'ManageEngine.ServiceDesk.OnPrem'
)

$targetModules = switch ($Module) {
    'Core'     { @('ManageEngine.ServiceDesk.OnPrem.Core') }
    'Requests' { @('ManageEngine.ServiceDesk.OnPrem.Core', 'ManageEngine.ServiceDesk.OnPrem.Requests') }
    'Changes'  { @('ManageEngine.ServiceDesk.OnPrem.Core', 'ManageEngine.ServiceDesk.OnPrem.Changes') }
    'All'      { $allModules }
}

function Invoke-BuildDocs {
    param([string[]]$Modules)

    Write-Host '[Docs] Generating documentation...' -ForegroundColor Cyan

    if (-not (Get-Module -ListAvailable -Name platyPS)) {
        throw 'platyPS module is required. Install it with: Install-Module platyPS -Scope CurrentUser'
    }

    Import-Module platyPS -Force

    # Meta module has no cmdlets; skip it
    $docModules = $Modules | Where-Object { $_ -ne 'ManageEngine.ServiceDesk.OnPrem' }

    foreach ($moduleName in $docModules) {
        $manifestPath = Join-Path $modulesDir $moduleName "$moduleName.psd1"
        $docsPath     = Join-Path $repoRoot 'docs' $moduleName 'en-US'
        $helpOutPath  = Join-Path $modulesDir $moduleName 'en-US'

        Import-Module $manifestPath -Force

        New-Item -ItemType Directory -Path $docsPath   -Force | Out-Null
        New-Item -ItemType Directory -Path $helpOutPath -Force | Out-Null

        New-MarkdownHelp -Module $moduleName -OutputFolder $docsPath -Force

        New-ExternalHelp -Path $docsPath -OutputPath $helpOutPath -Force | Out-Null

        Write-Host "[Docs]   $moduleName done." -ForegroundColor Green
    }

    Write-Host '[Docs] Done.' -ForegroundColor Green
}

function Invoke-BuildTest {
    Write-Host '[Test] Running unit tests...' -ForegroundColor Cyan

    if (-not (Get-Module -ListAvailable -Name Pester | Where-Object Version -ge '5.0')) {
        throw 'Pester 5.0 or later is required. Install it with: Install-Module Pester -Scope CurrentUser -Force'
    }

    $config = New-PesterConfiguration
    $config.Run.Path              = $testsDir
    $config.Run.PassThru          = $true
    $config.Filter.ExcludeTag     = @('Integration')
    $config.Output.Verbosity      = 'Detailed'
    $config.TestResult.Enabled    = $true
    $config.TestResult.OutputPath = Join-Path $repoRoot 'test-results.xml'

    $result = Invoke-Pester -Configuration $config

    if ($result.FailedCount -gt 0) {
        throw "[Test] $($result.FailedCount) test(s) failed."
    }

    Write-Host "[Test] All $($result.PassedCount) tests passed." -ForegroundColor Green
}

function Invoke-BuildIntegrationTest {
    param(
        [string[]]$Modules,
        [switch]$SkipCertificateCheck
    )

    Write-Host '[IntegrationTest] Running integration tests...' -ForegroundColor Cyan

    if (-not $env:SDP_BASE_URI) {
        throw 'SDP_BASE_URI environment variable is required for integration tests.'
    }

    $env:SDP_SKIP_CERTIFICATE_CHECK = if ($SkipCertificateCheck) { '1' } else { '' }

    $integrationDir = Join-Path $testsDir 'Integration'
    $moduleTestMap  = @{
        'ManageEngine.ServiceDesk.OnPrem.Requests' = Join-Path $integrationDir 'SDPRequests.Integration.Tests.ps1'
        'ManageEngine.ServiceDesk.OnPrem.Changes'  = Join-Path $integrationDir 'SDPChanges.Integration.Tests.ps1'
    }

    $testPaths = @(
        $Modules |
            Where-Object { $moduleTestMap.ContainsKey($_) } |
            ForEach-Object { $moduleTestMap[$_] } |
            Where-Object { Test-Path $_ }
    )

    if ($testPaths.Count -eq 0) {
        Write-Host '[IntegrationTest] No integration tests found for the selected module(s).' -ForegroundColor Yellow
        return
    }

    $config = New-PesterConfiguration
    $config.Run.Path         = $testPaths
    $config.Run.PassThru     = $true
    $config.Filter.Tag       = @('Integration')
    $config.Output.Verbosity = 'Detailed'

    $result = Invoke-Pester -Configuration $config

    if ($result.FailedCount -gt 0) {
        throw "[IntegrationTest] $($result.FailedCount) test(s) failed."
    }

    Write-Host "[IntegrationTest] All $($result.PassedCount) tests passed." -ForegroundColor Green
}

function Invoke-BuildPackage {
    param([string[]]$Modules)

    Write-Host '[Package] Creating distribution packages...' -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null

    foreach ($moduleName in $Modules) {
        $moduleDir    = Join-Path $modulesDir $moduleName
        $manifestPath = Join-Path $moduleDir "$moduleName.psd1"
        $version      = (Import-PowerShellDataFile $manifestPath).ModuleVersion
        $zipPath      = Join-Path $distDir "$moduleName.$version.zip"

        Compress-Archive -Path $moduleDir -DestinationPath $zipPath -Force
        Write-Host "[Package]   $moduleName $version → $zipPath" -ForegroundColor Green
    }

    Write-Host '[Package] Done.' -ForegroundColor Green
}

switch ($Task) {
    'Docs'            { Invoke-BuildDocs -Modules $targetModules }
    'Test'            { Invoke-BuildTest }
    'IntegrationTest' { Invoke-BuildIntegrationTest -Modules $targetModules -SkipCertificateCheck:$SkipCertificateCheck }
    'Package'         { Invoke-BuildPackage -Modules $targetModules }
    'All' {
        Invoke-BuildDocs -Modules $targetModules
        Invoke-BuildTest
        Invoke-BuildPackage -Modules $targetModules
    }
}
