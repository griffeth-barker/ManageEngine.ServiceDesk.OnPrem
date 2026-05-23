$script:SDPCompletionCache = @{}

$sdpCompleters = @(
    @{ Parameter = 'StatusName';      Endpoint = 'statuses';       Key = 'statuses';       Commands = @('New-SDPRequest', 'Set-SDPRequest', 'New-SDPRequestTask', 'Set-SDPRequestTask') }
    @{ Parameter = 'PriorityName';    Endpoint = 'priorities';     Key = 'priorities';     Commands = @('New-SDPRequest', 'Set-SDPRequest', 'New-SDPRequestTask', 'Set-SDPRequestTask') }
    @{ Parameter = 'UrgencyName';     Endpoint = 'urgencies';      Key = 'urgencies';      Commands = @('New-SDPRequest', 'Set-SDPRequest') }
    @{ Parameter = 'ImpactName';      Endpoint = 'impacts';        Key = 'impacts';        Commands = @('New-SDPRequest', 'Set-SDPRequest') }
    @{ Parameter = 'CategoryName';    Endpoint = 'categories';     Key = 'categories';     Commands = @('New-SDPRequest', 'Set-SDPRequest') }
    @{ Parameter = 'SiteName';        Endpoint = 'sites';          Key = 'sites';          Commands = @('New-SDPRequest', 'Set-SDPRequest') }
    @{ Parameter = 'ModeName';        Endpoint = 'modes';          Key = 'modes';          Commands = @('New-SDPRequest') }
    @{ Parameter = 'LevelName';       Endpoint = 'levels';         Key = 'levels';         Commands = @('New-SDPRequest') }
    @{ Parameter = 'RequestTypeName'; Endpoint = 'request_types';  Key = 'request_types';  Commands = @('New-SDPRequest') }
    @{ Parameter = 'GroupName';       Endpoint = 'support_groups'; Key = 'support_groups'; Commands = @('New-SDPRequest', 'Set-SDPRequest', 'New-SDPRequestTask', 'Set-SDPRequestTask') }
    @{ Parameter = 'TechnicianName';  Endpoint = 'technicians';    Key = 'technicians';    Commands = @('New-SDPRequest', 'Set-SDPRequest') }
    @{ Parameter = 'OwnerName';       Endpoint = 'technicians';    Key = 'technicians';    Commands = @('New-SDPRequestTask', 'Set-SDPRequestTask', 'New-SDPRequestWorklog', 'Set-SDPRequestWorklog') }
    @{ Parameter = 'RequesterName';   Endpoint = 'orgusers';       Key = 'orgusers';       Commands = @('New-SDPRequest', 'Set-SDPRequest') }
)

foreach ($completer in $sdpCompleters) {
    $sdpEndpoint = $completer.Endpoint
    $sdpKey      = $completer.Key
    $sdpCache    = $script:SDPCompletionCache

    $sb = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        if (-not $sdpCache.ContainsKey($sdpEndpoint)) {
            try {
                $r = Invoke-SDPRestMethod -Endpoint $sdpEndpoint
                $sdpCache[$sdpEndpoint] = @($r.$sdpKey | ForEach-Object { $_.name } | Where-Object { $_ })
            } catch {
                $sdpCache[$sdpEndpoint] = @()
            }
        }
        $sdpCache[$sdpEndpoint] | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            $completionText = if ($_ -match '\s') { "'$_'" } else { $_ }
            [System.Management.Automation.CompletionResult]::new($completionText, $_, 'ParameterValue', $_)
        }
    }.GetNewClosure()

    Register-ArgumentCompleter -CommandName $completer.Commands -ParameterName $completer.Parameter -ScriptBlock $sb
}
