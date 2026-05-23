function Set-SDPReminder {
    <#
    .SYNOPSIS
        Updates an existing reminder in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reminder to update.
    .PARAMETER Summary
        New summary text.
    .PARAMETER Date
        New date/time when the reminder fires.
    .PARAMETER RemindBeforeMs
        Advance alert interval in milliseconds.
    .EXAMPLE
        Set-SDPReminder -Id '10' -Summary 'Urgent: follow up on request 25'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReminder')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Summary,

        [Parameter()]
        [datetime]$Date,

        [Parameter()]
        [long]$RemindBeforeMs
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Summary'))       { $body['summary']        = $Summary }
        if ($PSBoundParameters.ContainsKey('Date'))          { $body['date']           = @{ value = [DateTimeOffset]::new($Date).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('RemindBeforeMs')) { $body['remind_before'] = $RemindBeforeMs }

        if ($PSCmdlet.ShouldProcess("Reminder $Id", 'Update SDP Reminder')) {
            $response = Invoke-SDPRestMethod -Endpoint "reminders/$Id" -Method PUT -Body @{ reminder = $body }
            [SDPReminder]::new($response.reminder)
        }
    }
}
