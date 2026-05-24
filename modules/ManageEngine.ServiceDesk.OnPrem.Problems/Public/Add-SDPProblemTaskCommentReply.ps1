function Add-SDPProblemTaskCommentReply {
    <#
    .SYNOPSIS
        Replies to a comment on a task for a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER TaskId
        The ID of the parent task.
    .PARAMETER CommentId
        The ID of the comment to reply to.
    .PARAMETER Description
        The content of the reply.
    .EXAMPLE
        Add-SDPProblemTaskCommentReply -ProblemId '12345' -TaskId '1' -CommentId '5' -Description 'Agreed, proceeding with that approach.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$TaskId,

        [Parameter(Mandatory)]
        [string]$CommentId,

        [Parameter(Mandatory)]
        [string]$Description
    )

    process {
        $body = @{ comment = @{ description = $Description } }

        if ($PSCmdlet.ShouldProcess("Comment $CommentId on Task $TaskId / Problem $ProblemId", 'Reply to comment')) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/tasks/$TaskId/comments/$CommentId/_reply" -Method POST -Body $body
            $response.comment
        }
    }
}
