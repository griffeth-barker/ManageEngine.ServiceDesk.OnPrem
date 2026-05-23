function Remove-SDPOrgUser {
    <#
    .SYNOPSIS
        Removes an org user from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the org user to remove.
    .EXAMPLE
        Remove-SDPOrgUser -Id '12345'
    .EXAMPLE
        Get-SDPOrgUser -All | Where-Object { $_.Department.Name -eq 'Contractors' } | Remove-SDPOrgUser
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Org User $Id", 'Remove SDP Org User')) {
            Invoke-SDPRestMethod -Endpoint "orgusers/$Id" -Method DELETE
        }
    }
}
