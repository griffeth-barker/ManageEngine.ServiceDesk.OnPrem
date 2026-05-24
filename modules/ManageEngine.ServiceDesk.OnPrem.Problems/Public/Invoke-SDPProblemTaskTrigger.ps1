function Invoke-SDPProblemTaskTrigger {
    <#
    .SYNOPSIS
        Triggers a task on a ServiceDesk Plus problem, moving it to the active state.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the task to trigger.
    .EXAMPLE
        Invoke-SDPProblemTaskTrigger -ProblemId '12345' -TaskId '1'
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
        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", 'Trigger SDP Problem task')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/_trigger" -Method PUT
        }
    }
}
