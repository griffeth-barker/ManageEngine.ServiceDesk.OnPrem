function Set-SDPProblemTask {
    <#
    .SYNOPSIS
        Updates a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the task to update.
    .PARAMETER Title
        Updated task title.
    .PARAMETER Description
        Updated description.
    .PARAMETER StatusName
        Name of the updated task status.
    .PARAMETER PriorityName
        Name of the updated priority.
    .PARAMETER OwnerName
        Name of the technician who owns the task.
    .PARAMETER GroupName
        Name of the group assigned to the task.
    .PARAMETER ScheduledStartTime
        Updated planned start date/time.
    .PARAMETER ScheduledEndTime
        Updated planned end date/time.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblemTask -ProblemId '12345' -Id '1' -StatusName 'In Progress'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

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
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))        { $body['title']       = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))  { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))   { $body['status']      = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName')) { $body['priority']    = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('OwnerName'))    { $body['owner']       = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))    { $body['group']       = @{ name = $GroupName } }

        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Task $Id on Problem $ProblemId", 'Update SDP Problem task')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$Id" -Method PUT -Body @{ task = $body }
            [SDPProblemTask]::new($ProblemId, $response.task)
        }
    }
}
