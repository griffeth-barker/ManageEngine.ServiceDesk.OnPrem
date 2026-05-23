function New-SDPChangeTask {
    <#
    .SYNOPSIS
        Creates a task on a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Title
        Title of the task.
    .PARAMETER Description
        Description of the task.
    .PARAMETER StatusName
        Name of the task status.
    .PARAMETER PriorityName
        Name of the task priority.
    .PARAMETER OwnerName
        Name of the task owner.
    .PARAMETER GroupName
        Name of the group assigned to the task.
    .PARAMETER ScheduledStartTime
        Planned start date/time.
    .PARAMETER ScheduledEndTime
        Planned end date/time.
    .EXAMPLE
        New-SDPChangeTask -ChangeId '12345' -Title 'Backup configuration'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [string]$GroupName,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime
    )

    process {
        $body = @{ title = $Title }

        if ($PSBoundParameters.ContainsKey('Description'))        { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))         { $body['status']      = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))       { $body['priority']    = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('OwnerName'))          { $body['owner']       = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))          { $body['group']       = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", 'Create SDP Change task')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/tasks" -Method POST -Body @{ task = $body }
            [SDPChangeTask]::new($ChangeId, $response.task)
        }
    }
}
