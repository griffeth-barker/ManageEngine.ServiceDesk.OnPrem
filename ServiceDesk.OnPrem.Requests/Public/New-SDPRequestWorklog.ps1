function New-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Adds a worklog entry to a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request.
    .PARAMETER Description
        Description of the work performed.
    .PARAMETER OwnerName
        Name of the technician who performed the work.
    .PARAMETER TimeSpentHours
        Hours of time spent (as a string, e.g. '2').
    .PARAMETER TimeSpentMinutes
        Minutes of time spent (as a string, e.g. '30').
    .PARAMETER StartTime
        Start time of the work.
    .PARAMETER EndTime
        End time of the work.
    .PARAMETER IncludeNonOperationalHours
        Whether to include non-operational hours in the time calculation.
    .PARAMETER MarkFirstResponse
        Marks this worklog as the first response.
    .PARAMETER AddTimeForLinkedRequests
        Applies the time entry to all linked requests.
    .EXAMPLE
        New-SDPRequestWorklog -RequestId '12345' -Description 'Investigated issue' -TimeSpentHours '1' -TimeSpentMinutes '30'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [string]$TimeSpentHours,

        [Parameter()]
        [string]$TimeSpentMinutes,

        [Parameter()]
        [datetime]$StartTime,

        [Parameter()]
        [datetime]$EndTime,

        [Parameter()]
        [switch]$IncludeNonOperationalHours,

        [Parameter()]
        [switch]$MarkFirstResponse,

        [Parameter()]
        [switch]$AddTimeForLinkedRequests
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))   { $body['owner']       = @{ name = $OwnerName } }
        if ($IncludeNonOperationalHours) { $body['include_nonoperational_hours'] = $true }
        if ($MarkFirstResponse)          { $body['mark_first_response']          = $true }
        if ($AddTimeForLinkedRequests)   { $body['add_time_for_linked_requests'] = $true }

        $timeSpent = @{}
        if ($PSBoundParameters.ContainsKey('TimeSpentHours'))   { $timeSpent['hours']   = $TimeSpentHours }
        if ($PSBoundParameters.ContainsKey('TimeSpentMinutes')) { $timeSpent['minutes'] = $TimeSpentMinutes }
        if ($timeSpent.Count -gt 0) { $body['time_spent'] = $timeSpent }

        if ($PSBoundParameters.ContainsKey('StartTime')) {
            $body['start_time'] = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('EndTime')) {
            $body['end_time'] = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() }
        }

        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Create SDP Request Worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs" -Method POST -Body @{ worklog = $body }
            [SDPRequestWorklog]::new($RequestId, $response.worklog)
        }
    }
}
