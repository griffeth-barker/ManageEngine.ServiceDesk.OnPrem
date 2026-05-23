function Remove-SDPChangeRole {
    <#
    .SYNOPSIS
        Deletes a change role from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change role to delete.
    .EXAMPLE
        Remove-SDPChangeRole -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Change role $Id", 'Delete SDP Change role')) {
        Invoke-SDPRestMethod -Endpoint "change_roles/$Id" -Method DELETE
    }
}
