function Remove-SDPTechnician {
    <#
    .SYNOPSIS
        Removes a technician from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the technician to remove.
    .EXAMPLE
        Remove-SDPTechnician -Id '12345'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Technician $Id", 'Remove SDP Technician')) {
            Invoke-SDPRestMethod -Endpoint "technicians/$Id" -Method DELETE
        }
    }
}
