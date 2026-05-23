function Remove-SDPMode {
    <#
    .SYNOPSIS
        Removes a mode from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the mode to remove.
    .EXAMPLE
        Remove-SDPMode -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Mode $Id", 'Remove SDP Mode')) {
            Invoke-SDPRestMethod -Endpoint "modes/$Id" -Method DELETE
        }
    }
}
