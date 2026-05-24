function Get-SDPProblemTaskWorklog {
    <#
    .SYNOPSIS
        Retrieves worklog entries for a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER Id
        The ID of a specific worklog entry to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1'
    .EXAMPLE
        Get-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1' -Id '67890'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPProblemWorklog')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory, ParameterSetName = 'WorklogId')]
        [string]$WorklogId,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'WorklogId') {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/worklogs/$WorklogId"
            [SDPProblemWorklog]::new($ProblemId, $TaskId, $response.worklog)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/worklogs" -InputData @{ list_info = $listInfo }
                foreach ($w in $response.worklogs) { [SDPProblemWorklog]::new($ProblemId, $TaskId, $w) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/worklogs" -InputData @{ list_info = $listInfo }
            foreach ($w in $response.worklogs) { [SDPProblemWorklog]::new($ProblemId, $TaskId, $w) }
        }
    }
}
