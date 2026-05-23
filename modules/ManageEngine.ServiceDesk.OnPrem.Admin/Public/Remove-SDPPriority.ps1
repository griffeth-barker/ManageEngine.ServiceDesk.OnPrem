function Remove-SDPPriority {
    <#
    .SYNOPSIS
        Removes a priority from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the priority to remove.
    .EXAMPLE
        Remove-SDPPriority -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Priority $Id", 'Remove SDP Priority')) {
            Invoke-SDPRestMethod -Endpoint "priorities/$Id" -Method DELETE
        }
    }
}
