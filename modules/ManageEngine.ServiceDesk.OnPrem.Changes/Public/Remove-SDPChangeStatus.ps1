function Remove-SDPChangeStatus {
    <#
    .SYNOPSIS
        Deletes a change status from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change status to delete.
    .EXAMPLE
        Remove-SDPChangeStatus -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Change status $Id", 'Delete SDP Change status')) {
        Invoke-SDPRestMethod -Endpoint "change_statuses/$Id" -Method DELETE
    }
}
