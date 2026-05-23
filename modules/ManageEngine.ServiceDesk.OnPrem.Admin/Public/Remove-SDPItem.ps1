function Remove-SDPItem {
    <#
    .SYNOPSIS
        Removes an item from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the item to remove.
    .EXAMPLE
        Remove-SDPItem -Id '100'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Item $Id", 'Remove SDP Item')) {
            Invoke-SDPRestMethod -Endpoint "items/$Id" -Method DELETE
        }
    }
}
