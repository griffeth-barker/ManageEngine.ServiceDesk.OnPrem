function Remove-SDPCAB {
    <#
    .SYNOPSIS
        Deletes a Change Advisory Board (CAB) from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the CAB to delete.
    .EXAMPLE
        Remove-SDPCAB -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    if ($PSCmdlet.ShouldProcess("CAB $Id", 'Delete SDP CAB')) {
        Invoke-SDPRestMethod -Endpoint "cabs/$Id" -Method DELETE
    }
}
