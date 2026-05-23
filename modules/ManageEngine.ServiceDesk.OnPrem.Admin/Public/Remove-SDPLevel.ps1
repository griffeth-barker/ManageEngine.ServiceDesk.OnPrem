function Remove-SDPLevel {
    <#
    .SYNOPSIS
        Removes a level from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the level to remove.
    .EXAMPLE
        Remove-SDPLevel -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Level $Id", 'Remove SDP Level')) {
            Invoke-SDPRestMethod -Endpoint "levels/$Id" -Method DELETE
        }
    }
}
