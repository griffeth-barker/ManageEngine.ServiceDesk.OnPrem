function Set-SDPProblemTaskComment {
    <#
    .SYNOPSIS
        Updates a comment on a task for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER Id
        The ID of the comment to update.
    .PARAMETER Description
        Updated content of the comment.
    .EXAMPLE
        Set-SDPProblemTaskComment -ProblemId '12345' -TaskId '1' -Id '5' -Description 'Analysis complete — 3 systems affected.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$TaskId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$Description
    )

    process {
        $body = @{ comment = @{ description = $Description } }

        if ($PSCmdlet.ShouldProcess("Comment $Id on Task $TaskId / Problem $ProblemId", 'Update comment')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/comments/$Id" -Method PUT -Body $body
            $response.comment
        }
    }
}
