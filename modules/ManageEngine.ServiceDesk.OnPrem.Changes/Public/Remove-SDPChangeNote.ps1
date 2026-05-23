function Remove-SDPChangeNote {
    <#
    .SYNOPSIS
        Deletes a note from a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the note to delete.
    .EXAMPLE
        Remove-SDPChangeNote -ChangeId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Note $Id on Change $ChangeId", 'Delete SDP Change note')) {
            Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/notes/$Id" -Method DELETE
        }
    }
}
