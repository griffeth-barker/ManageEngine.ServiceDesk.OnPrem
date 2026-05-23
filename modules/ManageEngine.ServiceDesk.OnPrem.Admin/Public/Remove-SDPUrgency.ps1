function Remove-SDPUrgency {
    <#
    .SYNOPSIS
        Removes a urgency from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the urgency to remove.
    .EXAMPLE
        Remove-SDPUrgency -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Urgency $Id", 'Remove SDP Urgency')) {
            Invoke-SDPRestMethod -Endpoint "urgencies/$Id" -Method DELETE
        }
    }
}
