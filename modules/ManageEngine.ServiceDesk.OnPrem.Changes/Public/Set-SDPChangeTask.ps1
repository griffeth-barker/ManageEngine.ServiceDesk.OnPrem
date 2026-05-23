function Set-SDPChangeTask {
    <#
    .SYNOPSIS
        Updates a task on a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the task to update.
    .PARAMETER Title
        Updated title.
    .PARAMETER Description
        Updated description.
    .PARAMETER StatusName
        Name of the task status.
    .PARAMETER PriorityName
        Name of the task priority.
    .PARAMETER OwnerName
        Name of the task owner.
    .PARAMETER GroupName
        Name of the group assigned to the task.
    .PARAMETER PercentageCompletion
        Completion percentage (0–100).
    .PARAMETER ScheduledStartTime
        Updated planned start date/time.
    .PARAMETER ScheduledEndTime
        Updated planned end date/time.
    .EXAMPLE
        Set-SDPChangeTask -ChangeId '12345' -Id '1' -StatusName 'Completed' -PercentageCompletion 100
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [ValidateRange(0, 100)]
        [int]$PercentageCompletion,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))               { $body['title']       = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))         { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))          { $body['status']      = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))        { $body['priority']    = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('OwnerName'))           { $body['owner']       = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))           { $body['group']       = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('PercentageCompletion')) { $body['percentage_completion'] = $PercentageCompletion }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Task $Id on Change $ChangeId", 'Update SDP Change task')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/tasks/$Id" -Method PUT -Body @{ task = $body }
            [SDPChangeTask]::new($ChangeId, $response.task)
        }
    }
}
