function New-SDPChangeDeploymentSchedule {
    <#
    .SYNOPSIS
        Creates a deployment (downtime) schedule for a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Description
        Description of the deployment schedule.
    .PARAMETER ScheduledStartTime
        Planned start date/time of the deployment window.
    .PARAMETER ScheduledEndTime
        Planned end date/time of the deployment window.
    .EXAMPLE
        New-SDPChangeDeploymentSchedule -ChangeId '12345' -Description 'Maintenance window' -ScheduledStartTime '2026-06-01 02:00' -ScheduledEndTime '2026-06-01 04:00'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeDeploymentSchedule')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))        { $body['description']       = $Description }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", 'Create SDP Change deployment schedule')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes" -Method POST -Body @{ downtime = $body }
            [SDPChangeDeploymentSchedule]::new($ChangeId, $response.downtime)
        }
    }
}
