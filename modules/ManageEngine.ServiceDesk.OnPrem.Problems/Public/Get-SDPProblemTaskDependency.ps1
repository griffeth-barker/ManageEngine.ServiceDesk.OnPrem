function Get-SDPProblemTaskDependency {
    <#
    .SYNOPSIS
        Retrieves task dependencies for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .EXAMPLE
        Get-SDPProblemTaskDependency -ProblemId '12345'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId
    )

    process {
        $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/task_dependencies"
        $response.task_dependencies
    }
}
