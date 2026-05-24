function Remove-SDPProblemNote {
    <#
    .SYNOPSIS
        Deletes a note from a ServiceDesk Plus problem.
    .PARAMETER ProblemId
        The ID of the parent problem.
    .PARAMETER Id
        The ID of the note to delete.
    .EXAMPLE
        Remove-SDPProblemNote -ProblemId '12345' -Id '67890'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ProblemId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Note $Id on Problem $ProblemId", 'Delete SDP Problem note')) {
            Invoke-SDPRestMethod -Endpoint "problems/$ProblemId/notes/$Id" -Method DELETE
        }
    }
}
