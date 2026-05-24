function Add-SDPProblemTaskDependency {
    <#
    .SYNOPSIS
        Adds a task dependency to a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the task that depends on another task.
    .PARAMETER DependsOnTaskId
        The ID of the task that must be completed first.
    .EXAMPLE
        Add-SDPProblemTaskDependency -ProblemId '12345' -TaskId '2' -DependsOnTaskId '1'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [string]$TaskId,

        [Parameter(Mandatory)]
        [string]$DependsOnTaskId
    )

    process {
        $body = @{ task_dependency = @{ task = @{ id = $TaskId }; depends_on_task = @{ id = $DependsOnTaskId } } }

        if ($PSCmdlet.ShouldProcess("Problem $ProblemId", "Add task dependency: Task $TaskId depends on Task $DependsOnTaskId")) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/task_dependencies" -Method POST -Body $body
        }
    }
}
