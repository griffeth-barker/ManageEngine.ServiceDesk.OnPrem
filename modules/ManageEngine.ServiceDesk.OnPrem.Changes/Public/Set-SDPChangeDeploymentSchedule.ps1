function Set-SDPChangeDeploymentSchedule {
    <#
    .SYNOPSIS
        Updates a deployment (downtime) schedule on a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the deployment schedule to update.
    .PARAMETER Description
        Updated description.
    .PARAMETER ScheduledStartTime
        Updated planned start date/time.
    .PARAMETER ScheduledEndTime
        Updated planned end date/time.
    .PARAMETER ActualStartTime
        Actual start date/time.
    .PARAMETER ActualEndTime
        Actual end date/time.
    .EXAMPLE
        Set-SDPChangeDeploymentSchedule -ChangeId '12345' -Id '1' -ActualStartTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeDeploymentSchedule')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [datetime]$ActualStartTime,

        [Parameter()]
        [datetime]$ActualEndTime
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))        { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ActualStartTime')) {
            $body['actual_start_time'] = @{ value = [DateTimeOffset]::new($ActualStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ActualEndTime')) {
            $body['actual_end_time'] = @{ value = [DateTimeOffset]::new($ActualEndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Deployment schedule $Id on Change $ChangeId", 'Update SDP Change deployment schedule')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes/$Id" -Method PUT -Body @{ downtime = $body }
            [SDPChangeDeploymentSchedule]::new($ChangeId, $response.downtime)
        }
    }
}
