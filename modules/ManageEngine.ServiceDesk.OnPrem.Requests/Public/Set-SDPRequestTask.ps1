function Set-SDPRequestTask {
    <#
    .SYNOPSIS
        Updates a task on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the task to update.
    .PARAMETER Title
        Updated task title.
    .PARAMETER Description
        Updated description.
    .PARAMETER OwnerName
        Name of the technician to assign as owner.
    .PARAMETER GroupName
        Name of the group to assign.
    .PARAMETER StatusName
        Name of the task status.
    .PARAMETER PriorityName
        Name of the task priority.
    .PARAMETER PercentageCompletion
        Updated completion percentage (0–100).
    .PARAMETER ScheduledStartTime
        Updated scheduled start date/time.
    .PARAMETER ScheduledEndTime
        Updated scheduled end date/time.
    .EXAMPLE
        Set-SDPRequestTask -RequestId '12345' -Id '1' -StatusName 'Completed' -PercentageCompletion 100
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [ValidateRange(0, 100)]
        [int]$PercentageCompletion,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))               { $body['title']                 = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))         { $body['description']           = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))           { $body['owner']                 = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))           { $body['group']                 = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('StatusName'))          { $body['status']                = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))        { $body['priority']              = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('PercentageCompletion')){ $body['percentage_completion'] = $PercentageCompletion }
        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Task $Id on Request $RequestId", 'Update SDP Request Task')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$Id" -Method PUT -Body @{ task = $body }
            [SDPRequestTask]::new($RequestId, $response.task)
        }
    }
}
