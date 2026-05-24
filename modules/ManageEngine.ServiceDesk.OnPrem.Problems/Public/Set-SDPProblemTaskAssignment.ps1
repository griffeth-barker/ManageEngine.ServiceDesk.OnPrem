function Set-SDPProblemTaskAssignment {
    <#
    .SYNOPSIS
        Assigns a task on a ServiceDesk Plus problem to a technician.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the task to assign.
    .PARAMETER TechnicianName
        Name of the technician to assign as owner.
    .EXAMPLE
        Set-SDPProblemTaskAssignment -ProblemId '12345' -TaskId '1' -TechnicianName 'Bob Jones'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory)]
        [string]$TechnicianName
    )

    process {
        $body = @{ task = @{ owner = @{ name = $TechnicianName } } }

        if ($PSCmdlet.ShouldProcess("Task $TaskId on Problem $ProblemId", "Assign to $TechnicianName")) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/_assign" -Method PUT -Body $body
        }
    }
}
