#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('All', 'Docs', 'Test', 'IntegrationTest', 'Package')]
    [string]$Task = 'All'
)

$ErrorActionPreference = 'Stop'

$moduleName  = 'ServiceDesk.OnPrem.Requests'
$moduleRoot  = Join-Path $PSScriptRoot $moduleName
$manifestPath = Join-Path $moduleRoot "$moduleName.psd1"
$docsPath    = Join-Path $PSScriptRoot 'docs' 'en-US'
$helpOutPath = Join-Path $moduleRoot 'en-US'
$testsPath   = Join-Path $PSScriptRoot 'tests'
$distPath    = Join-Path $PSScriptRoot 'dist'

function Invoke-BuildDocs {
    Write-Host '[Docs] Generating documentation...' -ForegroundColor Cyan

    if (-not (Get-Module -ListAvailable -Name platyPS)) {
        throw 'platyPS module is required. Install it with: Install-Module platyPS -Scope CurrentUser'
    }

    Import-Module platyPS -Force
    Import-Module $manifestPath -Force

    New-Item -ItemType Directory -Path $docsPath   -Force | Out-Null
    New-Item -ItemType Directory -Path $helpOutPath -Force | Out-Null

    $existingDocs = Get-ChildItem -Path $docsPath -Filter '*.md' -ErrorAction SilentlyContinue
    if ($existingDocs) {
        Update-MarkdownHelp -Path $docsPath -Force | Out-Null
    } else {
        New-MarkdownHelp -Module $moduleName -OutputFolder $docsPath -Force | Out-Null
    }

    New-ExternalHelp -Path $docsPath -OutputPath $helpOutPath -Force | Out-Null

    Write-Host '[Docs] Done.' -ForegroundColor Green
}

function Invoke-BuildTest {
    Write-Host '[Test] Running unit tests...' -ForegroundColor Cyan

    if (-not (Get-Module -ListAvailable -Name Pester | Where-Object Version -ge '5.0')) {
        throw 'Pester 5.0 or later is required. Install it with: Install-Module Pester -Scope CurrentUser -Force'
    }

    $config = New-PesterConfiguration
    $config.Run.Path             = $testsPath
    $config.Run.PassThru         = $true
    $config.Filter.ExcludeTag    = @('Integration')
    $config.Output.Verbosity     = 'Detailed'
    $config.TestResult.Enabled   = $true
    $config.TestResult.OutputPath = Join-Path $PSScriptRoot 'test-results.xml'

    $result = Invoke-Pester -Configuration $config

    if ($result.FailedCount -gt 0) {
        throw "[Test] $($result.FailedCount) test(s) failed."
    }

    Write-Host "[Test] All $($result.PassedCount) tests passed." -ForegroundColor Green
}

function Invoke-BuildIntegrationTest {
    Write-Host '[IntegrationTest] Running integration tests...' -ForegroundColor Cyan

    if (-not $env:SDP_BASE_URI) {
        throw 'SDP_BASE_URI environment variable is required for integration tests.'
    }

    $config = New-PesterConfiguration
    $config.Run.Path         = $testsPath
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
    Write-Host '[Package] Creating distribution package...' -ForegroundColor Cyan

    $version = (Import-PowerShellDataFile $manifestPath).ModuleVersion
    New-Item -ItemType Directory -Path $distPath -Force | Out-Null

    $zipPath = Join-Path $distPath "$moduleName.$version.zip"
    Compress-Archive -Path $moduleRoot -DestinationPath $zipPath -Force

    Write-Host "[Package] Created $zipPath" -ForegroundColor Green
}

switch ($Task) {
    'Docs'            { Invoke-BuildDocs }
    'Test'            { Invoke-BuildTest }
    'IntegrationTest' { Invoke-BuildIntegrationTest }
    'Package'         { Invoke-BuildPackage }
    'All' {
        Invoke-BuildDocs
        Invoke-BuildTest
        Invoke-BuildPackage
    }
}
