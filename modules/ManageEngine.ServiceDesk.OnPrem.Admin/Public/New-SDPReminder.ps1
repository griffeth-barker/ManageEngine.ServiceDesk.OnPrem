function New-SDPReminder {
    <#
    .SYNOPSIS
        Creates a new reminder in ServiceDesk Plus.
    .PARAMETER Summary
        Summary text of the reminder.
    .PARAMETER Date
        Date/time when the reminder fires.
    .PARAMETER RemindBeforeMs
        Number of milliseconds before the reminder date to send an advance alert.
    .EXAMPLE
        New-SDPReminder -Summary 'Follow up on request 25' -Date (Get-Date).AddDays(1)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReminder')]
    param(
        [Parameter(Mandatory)]
        [string]$Summary,

        [Parameter(Mandatory)]
        [datetime]$Date,

        [Parameter()]
        [long]$RemindBeforeMs
    )

    $body = @{
        summary = $Summary
        date    = @{ value = [DateTimeOffset]::new($Date).ToUnixTimeMilliseconds() }
    }

    if ($PSBoundParameters.ContainsKey('RemindBeforeMs')) { $body['remind_before'] = $RemindBeforeMs }

    if ($PSCmdlet.ShouldProcess($Summary, 'Create SDP Reminder')) {
        $response = Invoke-SDPRestMethod -Endpoint 'reminders' -Method POST -Body @{ reminder = $body }
        [SDPReminder]::new($response.reminder)
    }
}
