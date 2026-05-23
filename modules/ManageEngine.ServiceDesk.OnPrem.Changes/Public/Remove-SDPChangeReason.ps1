function Remove-SDPChangeReason {
    <#
    .SYNOPSIS
        Deletes a reason for change from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reason for change to delete.
    .EXAMPLE
        Remove-SDPChangeReason -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Change reason $Id", 'Delete SDP Change reason')) {
        Invoke-SDPRestMethod -Endpoint "reasons_for_change/$Id" -Method DELETE
    }
}
