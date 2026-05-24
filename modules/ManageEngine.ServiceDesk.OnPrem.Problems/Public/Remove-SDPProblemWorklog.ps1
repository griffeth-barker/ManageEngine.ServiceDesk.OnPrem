function Remove-SDPProblemWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the worklog entry to delete.
    .EXAMPLE
        Remove-SDPProblemWorklog -ProblemId '12345' -Id '67890'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Problem $ProblemId", 'Delete SDP Problem worklog')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/worklogs/$Id" -Method DELETE
        }
    }
}
