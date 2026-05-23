function Remove-SDPImpact {
    <#
    .SYNOPSIS
        Removes a impact from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the impact to remove.
    .EXAMPLE
        Remove-SDPImpact -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Impact $Id", 'Remove SDP Impact')) {
            Invoke-SDPRestMethod -Endpoint "impacts/$Id" -Method DELETE
        }
    }
}
