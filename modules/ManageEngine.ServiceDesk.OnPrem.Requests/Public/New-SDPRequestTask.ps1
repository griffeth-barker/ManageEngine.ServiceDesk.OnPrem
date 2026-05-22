function New-SDPRequestTask {
    <#
    .SYNOPSIS
        Creates a task on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request to add the task to.
    .PARAMETER Title
        The task title.
    .PARAMETER Description
        Description of the task.
    .PARAMETER OwnerName
        Name of the technician to assign as owner.
    .PARAMETER GroupName
        Name of the group to assign.
    .PARAMETER StatusName
        Name of the task status.
    .PARAMETER PriorityName
        Name of the task priority.
    .PARAMETER TypeName
        Name of the task type.
    .PARAMETER PercentageCompletion
        Completion percentage (0–100).
    .PARAMETER ScheduledStartTime
        Scheduled start date/time.
    .PARAMETER ScheduledEndTime
        Scheduled end date/time.
    .PARAMETER EstimatedHours
        Estimated effort in hours.
    .PARAMETER EstimatedMinutes
        Estimated effort in minutes.
    .EXAMPLE
        New-SDPRequestTask -RequestId '12345' -Title 'Verify network connectivity'
    .EXAMPLE
        New-SDPRequestTask -RequestId '12345' -Title 'Deploy fix' -OwnerName 'Bob Jones' -PriorityName 'High'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [string]$GroupName,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$TypeName,

        [Parameter()]
        [ValidateRange(0, 100)]
        [int]$PercentageCompletion,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [string]$EstimatedHours,

        [Parameter()]
        [string]$EstimatedMinutes
    )

    process {
        $body = @{ title = $Title }

        if ($PSBoundParameters.ContainsKey('Description'))         { $body['description']          = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))           { $body['owner']                = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))           { $body['group']                = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('StatusName'))          { $body['status']               = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))        { $body['priority']             = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('TypeName'))            { $body['type']                 = @{ name = $TypeName } }
        if ($PSBoundParameters.ContainsKey('PercentageCompletion')){ $body['percentage_completion'] = $PercentageCompletion }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        $effort = @{}
        if ($PSBoundParameters.ContainsKey('EstimatedHours'))   { $effort['hours']   = $EstimatedHours }
        if ($PSBoundParameters.ContainsKey('EstimatedMinutes')) { $effort['minutes'] = $EstimatedMinutes }
        if ($effort.Count -gt 0) { $body['estimated_effort'] = $effort }

        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Create SDP Request Task')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks" -Method POST -Body @{ task = $body }
            [SDPRequestTask]::new($RequestId, $response.task)
        }
    }
}
