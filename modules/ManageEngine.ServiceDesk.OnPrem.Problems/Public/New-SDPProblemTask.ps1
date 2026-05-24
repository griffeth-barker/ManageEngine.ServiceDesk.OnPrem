function New-SDPProblemTask {
    <#
    .SYNOPSIS
        Adds a task to a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Title
        The title of the task.
    .PARAMETER Description
        Description of the task.
    .PARAMETER StatusName
        Name of the task status.
    .PARAMETER PriorityName
        Name of the task priority.
    .PARAMETER OwnerName
        Name of the technician who owns the task.
    .PARAMETER GroupName
        Name of the group assigned to the task.
    .PARAMETER ScheduledStartTime
        Planned start date/time.
    .PARAMETER ScheduledEndTime
        Planned end date/time.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body.
    .EXAMPLE
        New-SDPProblemTask -ProblemId '12345' -Title 'Analyse affected systems'
    .EXAMPLE
        New-SDPProblemTask -ProblemId '12345' -Title 'Deploy fix' -OwnerName 'Bob Jones' -PriorityName 'High'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

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
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{ title = $Title }

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

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", "Add task '$Title'")) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks" -Method POST -Body @{ task = $body }
            [SDPProblemTask]::new($ProblemId, $response.task)
        }
    }
}
