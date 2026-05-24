function Close-SDPProblemTask {
    <#
    .SYNOPSIS
        Closes a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the task to close.
    .EXAMPLE
        Close-SDPProblemTask -ProblemId '12345' -TaskId '1'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId
    )

    process {
        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", 'Close SDP Problem task')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/_close" -Method PUT
        }
    }
}
