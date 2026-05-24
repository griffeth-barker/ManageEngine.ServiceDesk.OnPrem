function Set-SDPProblemWorklog {
    <#
    .SYNOPSIS
        Updates a worklog entry on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the worklog entry to update.
    .PARAMETER Description
        Updated description.
    .PARAMETER OwnerName
        Updated owner technician name.
    .PARAMETER StartTime
        Updated work start date/time.
    .PARAMETER EndTime
        Updated work end date/time.
    .PARAMETER IncludeNonOperationalHours
        When specified, non-operational hours are included in the time calculation.
    .EXAMPLE
        Set-SDPProblemWorklog -ProblemId '12345' -Id '67890' -Description 'Corrected time entry.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [datetime]$StartTime,

        [Parameter()]
        [datetime]$EndTime,

        [Parameter()]
        [bool]$IncludeNonOperationalHours
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Description'))  { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))    { $body['owner']       = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('StartTime'))    { $body['start_time']  = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('EndTime'))      { $body['end_time']    = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('IncludeNonOperationalHours')) {
            $body['include_nonoperational_hours'] = $IncludeNonOperationalHours
        }

        if ($PSCmdlet.ShouldProcess("Worklog $Id on Problem $ProblemId", 'Update SDP Problem worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/worklogs/$Id" -Method PUT -Body @{ worklog = $body }
            [SDPProblemWorklog]::new($ProblemId, $response.worklog)
        }
    }
}
