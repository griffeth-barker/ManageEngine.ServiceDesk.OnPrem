function New-SDPProblemTaskComment {
    <#
    .SYNOPSIS
        Adds a comment to a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER Description
        The content of the comment.
    .EXAMPLE
        New-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Description 'Starting system analysis now.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory)]
        [string]$Description
    )

    process {
        $body = @{ comment = @{ description = $Description } }

        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", 'Add comment')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/comments" -Method POST -Body $body
            $response.comment
        }
    }
}
