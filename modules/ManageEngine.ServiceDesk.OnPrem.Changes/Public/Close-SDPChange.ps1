function Close-SDPChange {
    <#
    .SYNOPSIS
        Closes one or more changes in ServiceDesk Plus.
    .PARAMETER Id
        One or more change IDs to close.
    .PARAMETER ClosureCodeName
        Name of the closure code to apply.
    .PARAMETER Comments
        Optional closure comments.
    .EXAMPLE
        Close-SDPChange -Id '12345'
    .EXAMPLE
        Close-SDPChange -Id '12345','67890' -ClosureCodeName 'Successful'
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
        $idsParam = $Id -join ','

        $body = @{}
        if ($PSBoundParameters.ContainsKey('ClosureCodeName')) { $body['closure_code'] = @{ name = $ClosureCodeName } }
        if ($PSBoundParameters.ContainsKey('Comments'))        { $body['closure_comments'] = $Comments }

        if ($PSCmdlet.ShouldProcess("Change(s) $idsParam", 'Close SDP Change(s)')) {
            $params = @{
                Endpoint = "changes/close?ids=$idsParam"
                Method   = 'PUT'
            }
            if ($body.Count -gt 0) { $params['Body'] = @{ change = $body } }
            Invoke-SDPRestMethod @params
        }
    }
}
