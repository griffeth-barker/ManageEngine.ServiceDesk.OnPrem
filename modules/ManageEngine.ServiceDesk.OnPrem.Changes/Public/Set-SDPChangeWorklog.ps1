function Set-SDPChangeWorklog {
    <#
    .SYNOPSIS
        Updates a worklog entry on a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the worklog to update.
    .PARAMETER Description
        Updated description.
    .PARAMETER OwnerName
        Updated owner name.
    .PARAMETER StartTime
        Updated start date/time.
    .PARAMETER EndTime
        Updated end date/time.
    .PARAMETER IncludeNonOperationalHours
        Updated non-operational hours flag.
    .EXAMPLE
        Set-SDPChangeWorklog -ChangeId '12345' -Id '1' -Description 'Corrected time entry.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

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

        if ($PSBoundParameters.ContainsKey('Description'))               { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('OwnerName'))                 { $body['owner']       = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('StartTime'))                 { $body['start_time']  = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('EndTime'))                   { $body['end_time']    = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('IncludeNonOperationalHours')) { $body['include_nonoperational_hours'] = $IncludeNonOperationalHours }

        if ($PSCmdlet.ShouldProcess("Worklog $Id on Change $ChangeId", 'Update SDP Change worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/worklogs/$Id" -Method PUT -Body @{ worklog = $body }
            [SDPChangeWorklog]::new($ChangeId, $response.worklog)
        }
    }
}
