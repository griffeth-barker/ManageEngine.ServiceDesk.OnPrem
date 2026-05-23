function Open-SDPReminder {
    <#
    .SYNOPSIS
        Re-opens a closed reminder in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reminder to re-open.
    .EXAMPLE
        Open-SDPReminder -Id '10'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Reminder $Id", 'Re-open SDP Reminder')) {
            Invoke-SDPRestMethod -Endpoint "reminders/$Id/_open" -Method PUT
        }
    }
}
