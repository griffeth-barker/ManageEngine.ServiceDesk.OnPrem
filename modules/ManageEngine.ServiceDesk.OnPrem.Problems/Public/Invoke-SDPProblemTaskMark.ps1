function Invoke-SDPProblemTaskMark {
    <#
    .SYNOPSIS
        Marks the current technician as the owner/performer of a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the task to mark.
    .EXAMPLE
        Invoke-SDPProblemTaskMark -ProblemId '12345' -TaskId '1'
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
        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", 'Mark SDP Problem task')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/_mark" -Method PUT
        }
    }
}
