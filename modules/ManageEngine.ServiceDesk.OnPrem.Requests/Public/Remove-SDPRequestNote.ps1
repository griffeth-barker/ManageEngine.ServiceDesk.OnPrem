function Remove-SDPRequestNote {
    <#
    .SYNOPSIS
        Deletes a note from a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the note to delete.
    .EXAMPLE
        Remove-SDPRequestNote -RequestId '12345' -Id '67890'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Note $Id on Request $RequestId", 'Delete SDP Request Note')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/notes/$Id" -Method DELETE
        }
    }
}
