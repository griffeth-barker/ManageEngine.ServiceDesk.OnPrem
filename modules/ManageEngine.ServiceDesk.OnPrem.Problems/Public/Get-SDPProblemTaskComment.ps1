function Get-SDPProblemTaskComment {
    <#
    .SYNOPSIS
        Retrieves comments on a task for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .EXAMPLE
        Get-SDPProblemTaskComment -ProblemId '12345' -TaskId '1'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter()]
        [int]$StartIndex = 1
    )

    process {
        $listInfo = @{ row_count = $PageSize; start_index = $StartIndex }
        $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/comments" -InputData @{ list_info = $listInfo }
        $response.comments
    }
}
