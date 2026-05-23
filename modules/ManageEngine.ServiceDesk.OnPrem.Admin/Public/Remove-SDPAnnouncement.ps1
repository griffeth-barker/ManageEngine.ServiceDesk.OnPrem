function Remove-SDPAnnouncement {
    <#
    .SYNOPSIS
        Removes an announcement from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the announcement to remove.
    .EXAMPLE
        Remove-SDPAnnouncement -Id '5'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Announcement $Id", 'Remove SDP Announcement')) {
            Invoke-SDPRestMethod -Endpoint "announcements/$Id" -Method DELETE
        }
    }
}
