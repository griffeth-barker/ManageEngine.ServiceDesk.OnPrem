function Remove-SDPUser {
    <#
    .SYNOPSIS
        Removes a user from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the user to remove.
    .EXAMPLE
        Remove-SDPUser -Id '12345'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("User $Id", 'Remove SDP User')) {
            Invoke-SDPRestMethod -Endpoint "users/$Id" -Method DELETE
        }
    }
}
