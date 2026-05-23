function Remove-SDPChangeType {
    <#
    .SYNOPSIS
        Deletes a change type from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change type to delete.
    .EXAMPLE
        Remove-SDPChangeType -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Change type $Id", 'Delete SDP Change type')) {
        Invoke-SDPRestMethod -Endpoint "change_types/$Id" -Method DELETE
    }
}
