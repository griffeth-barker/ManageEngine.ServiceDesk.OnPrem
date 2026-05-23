function Remove-SDPChangeRisk {
    <#
    .SYNOPSIS
        Deletes a risk level from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the risk to delete.
    .EXAMPLE
        Remove-SDPChangeRisk -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("Risk $Id", 'Delete SDP Change risk')) {
        Invoke-SDPRestMethod -Endpoint "risks/$Id" -Method DELETE
    }
}
