$script:SDPAdminCompletionCache = @{}

$sdpAdminCompleters = @(
    @{ Parameter = 'RegionId';      Endpoint = 'regions';        Key = 'regions';        Commands = @('New-SDPSite', 'Set-SDPSite', 'New-SDPRegion', 'Set-SDPRegion') }
    @{ Parameter = 'SiteId';        Endpoint = 'sites';          Key = 'sites';          Commands = @('New-SDPDepartment', 'Set-SDPDepartment', 'New-SDPSupportGroup', 'Set-SDPSupportGroup') }
    @{ Parameter = 'DepartmentId';  Endpoint = 'departments';    Key = 'departments';    Commands = @('New-SDPOrgUser', 'Set-SDPOrgUser', 'New-SDPUser', 'Set-SDPUser', 'New-SDPTechnician', 'Set-SDPTechnician') }
    @{ Parameter = 'CategoryId';    Endpoint = 'categories';     Key = 'categories';     Commands = @('Get-SDPSubcategory', 'New-SDPSubcategory', 'Set-SDPSubcategory') }
)

foreach ($completer in $sdpAdminCompleters) {
    $sdpEndpoint = $completer.Endpoint
    $sdpKey      = $completer.Key
    $sdpCache    = $script:SDPAdminCompletionCache

    $sb = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        if (-not $sdpCache.ContainsKey($sdpEndpoint)) {
            try {
                $r = Invoke-SDPRestMethod -Endpoint $sdpEndpoint
                $sdpCache[$sdpEndpoint] = @($r.$sdpKey | ForEach-Object { [pscustomobject]@{ Id = $_.id; Name = $_.name } })
            } catch {
                $sdpCache[$sdpEndpoint] = @()
            }
        }
        $sdpCache[$sdpEndpoint] |
            Where-Object { $_.Id -like "$wordToComplete*" -or $_.Name -like "*$wordToComplete*" } |
            ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_.Id, "$($_.Id) ($($_.Name))", 'ParameterValue', $_.Name)
            }
    }.GetNewClosure()

    Register-ArgumentCompleter -CommandName $completer.Commands -ParameterName $completer.Parameter -ScriptBlock $sb
}
