function Remove-SDPProblemTaskComment {
    <#
    .SYNOPSIS
        Deletes a comment from a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER Id
        The ID of the comment to delete.
    .EXAMPLE
        Remove-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Id '5'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$TaskId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Comment $Id on Task $TaskId / Problem $ProblemId", 'Delete comment')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/comments/$Id" -Method DELETE
        }
    }
}
