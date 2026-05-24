function Remove-SDPProblemTask {
    <#
    .SYNOPSIS
        Deletes a task from a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the task to delete.
    .EXAMPLE
        Remove-SDPProblemTask -ProblemId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Task $Id on Problem $ProblemId", 'Delete SDP Problem task')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$Id" -Method DELETE
        }
    }
}
