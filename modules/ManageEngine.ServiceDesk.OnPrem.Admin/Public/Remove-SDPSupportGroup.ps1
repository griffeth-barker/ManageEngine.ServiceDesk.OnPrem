function Remove-SDPSupportGroup {
    <#
    .SYNOPSIS
        Removes a support group from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the support group to remove.
    .EXAMPLE
        Remove-SDPSupportGroup -Id '7'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Support Group $Id", 'Remove SDP Support Group')) {
            Invoke-SDPRestMethod -Endpoint "support_groups/$Id" -Method DELETE
        }
    }
}
