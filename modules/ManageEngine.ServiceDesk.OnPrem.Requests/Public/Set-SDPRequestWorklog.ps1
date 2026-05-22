function Set-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Updates a worklog entry on a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the worklog to update.
    .PARAMETER Description
        Updated description.
    .PARAMETER OwnerName
        Updated technician name.
    .PARAMETER TimeSpentHours
        Updated hours spent.
    .PARAMETER TimeSpentMinutes
        Updated minutes spent.
    .PARAMETER MarkFirstResponse
        Marks this worklog as the first response.
    .EXAMPLE
        Set-SDPRequestWorklog -RequestId '12345' -Id '1' -Description 'Updated work notes' -TimeSpentHours '2'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [string]$TimeSpentHours,

        [Parameter()]
        [string]$TimeSpentMinutes,

        [Parameter()]
        [switch]$MarkFirstResponse
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))   { $body['owner']       = @{ name = $OwnerName } }
        if ($MarkFirstResponse) { $body['mark_first_response'] = $true }

        $timeSpent = @{}
        if ($PSBoundParameters.ContainsKey('TimeSpentHours'))   { $timeSpent['hours']   = $TimeSpentHours }
        if ($PSBoundParameters.ContainsKey('TimeSpentMinutes')) { $timeSpent['minutes'] = $TimeSpentMinutes }
        if ($timeSpent.Count -gt 0) { $body['time_spent'] = $timeSpent }

        if ($PSCmdlet.ShouldProcess("Worklog $Id on Request $RequestId", 'Update SDP Request Worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs/$Id" -Method PUT -Body @{ worklog = $body }
            [SDPRequestWorklog]::new($RequestId, $response.worklog)
        }
    }
}
