function Close-SDPProblem {
    <#
    .SYNOPSIS
        Closes one or more problems in ServiceDesk Plus.
    .PARAMETER Id
        One or more problem IDs to close.
    .PARAMETER ClosureCodeName
        Name of the closure code to apply.
    .PARAMETER Comments
        Optional closure comments.
    .EXAMPLE
        Close-SDPProblem -Id '12345'
    .EXAMPLE
        Close-SDPProblem -Id '12345' -ClosureCodeName 'Resolved' -Comments 'Root cause eliminated.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id,

        [Parameter()]
        [string]$ClosureCodeName,

        [Parameter()]
        [string]$Comments
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('ClosureCodeName')) { $body['closure_code']     = @{ name = $ClosureCodeName } }
        if ($PSBoundParameters.ContainsKey('Comments'))        { $body['closure_comments'] = $Comments }

        foreach ($problemId in $Id) {
            if ($PSCmdlet.ShouldProcess("Problem $problemId", 'Close SDP Problem')) {
                $params = @{ Endpoint = "problems/$problemId/close"; Method = 'PUT' }
                if ($body.Count -gt 0) { $params['Body'] = @{ problem = $body } }
                Invoke-SDPRestMethod @params
            }
        }
    }
}
