function Remove-SDPProblemTaskWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a task on a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER Id
        The ID of the worklog entry to delete.
    .EXAMPLE
        Remove-SDPProblemTaskWorklog -ProblemId '12345' -TaskId '1' -Id '67890'
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
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Task $TaskId / Problem $ProblemId", 'Delete worklog')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/worklogs/$Id" -Method DELETE
        }
    }
}
