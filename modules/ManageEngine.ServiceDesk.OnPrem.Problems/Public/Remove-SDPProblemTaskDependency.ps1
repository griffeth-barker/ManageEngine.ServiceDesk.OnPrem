function Remove-SDPProblemTaskDependency {
    <#
    .SYNOPSIS
        Removes a task dependency from a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER DependencyId
        The ID of the task dependency to remove.
    .EXAMPLE
        Remove-SDPProblemTaskDependency -ProblemId '12345' -DependencyId '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory)]
        [string]$DependencyId
    )

    process {
        if ($PSCmdlet.ShouldProcess("Dependency $DependencyId on Problem $ProblemId", 'Remove SDP Problem task dependency')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/task_dependencies/$DependencyId" -Method DELETE
        }
    }
}
