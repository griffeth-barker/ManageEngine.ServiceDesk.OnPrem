function New-SDPChangeWorklog {
    <#
    .SYNOPSIS
        Adds a worklog entry to a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Description
        Description of the work performed.
    .PARAMETER OwnerName
        Name of the technician who performed the work.
    .PARAMETER StartTime
        Work start date/time.
    .PARAMETER EndTime
        Work end date/time.
    .PARAMETER IncludeNonOperationalHours
        When specified, non-operational hours are included in the time calculation.
    .EXAMPLE
        New-SDPChangeWorklog -ChangeId '12345' -Description 'Applied patches' -OwnerName 'Bob Jones' -StartTime (Get-Date).AddHours(-2) -EndTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChangeWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter()]
        [string]$OwnerName,

        [Parameter()]
        [datetime]$StartTime,

        [Parameter()]
        [datetime]$EndTime,

        [Parameter()]
        [switch]$IncludeNonOperationalHours
    )

    process {
        $body = @{ description = $Description }

        if ($PSBoundParameters.ContainsKey('OwnerName'))  { $body['owner'] = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('StartTime'))  { $body['start_time'] = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('EndTime'))    { $body['end_time']   = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() } }
        if ($IncludeNonOperationalHours)                  { $body['include_nonoperational_hours'] = $true }

        if ($PSCmdlet.ShouldProcess("Change $ChangeId", 'Add worklog to SDP Change')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/worklogs" -Method POST -Body @{ worklog = $body }
            [SDPChangeWorklog]::new($ChangeId, $response.worklog)
        }
    }
}
