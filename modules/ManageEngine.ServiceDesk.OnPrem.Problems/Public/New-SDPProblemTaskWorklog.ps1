function New-SDPProblemTaskWorklog {
    <#
    .SYNOPSIS
        Adds a worklog entry to a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
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
        New-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1' -Description 'Ran diagnostics' -OwnerName 'Bob Jones' -StartTime (Get-Date).AddHours(-1) -EndTime (Get-Date)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblemWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

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

        if ($PSBoundParameters.ContainsKey('OwnerName'))  { $body['owner']      = @{ name = $OwnerName } }
        if ($PSBoundParameters.ContainsKey('StartTime'))  { $body['start_time'] = @{ value = [DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() } }
        if ($PSBoundParameters.ContainsKey('EndTime'))    { $body['end_time']   = @{ value = [DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() } }
        if ($IncludeNonOperationalHours)                  { $body['include_nonoperational_hours'] = $true }

        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", 'Add worklog')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/worklogs" -Method POST -Body @{ worklog = $body }
            [SDPProblemWorklog]::new($ProblemId, $TaskId, $response.worklog)
        }
    }
}
