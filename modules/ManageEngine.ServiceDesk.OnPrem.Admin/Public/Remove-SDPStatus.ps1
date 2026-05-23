function Remove-SDPStatus {
    <#
    .SYNOPSIS
        Removes a status from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the status to remove.
    .EXAMPLE
        Remove-SDPStatus -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Status $Id", 'Remove SDP Status')) {
            Invoke-SDPRestMethod -Endpoint "statuses/$Id" -Method DELETE
        }
    }
}
