function Remove-SDPReminder {
    <#
    .SYNOPSIS
        Removes a reminder from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reminder to remove.
    .EXAMPLE
        Remove-SDPReminder -Id '10'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Reminder $Id", 'Remove SDP Reminder')) {
            Invoke-SDPRestMethod -Endpoint "reminders/$Id" -Method DELETE
        }
    }
}
