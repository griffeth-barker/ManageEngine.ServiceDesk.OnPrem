function Close-SDPReminder {
    <#
    .SYNOPSIS
        Closes a reminder in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reminder to close.
    .EXAMPLE
        Close-SDPReminder -Id '10'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Reminder $Id", 'Close SDP Reminder')) {
            Invoke-SDPRestMethod -Endpoint "reminders/$Id/_close" -Method PUT
        }
    }
}
