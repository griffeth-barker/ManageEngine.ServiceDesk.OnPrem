function Remove-SDPChangeWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the worklog to delete.
    .EXAMPLE
        Remove-SDPChangeWorklog -ChangeId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Change $ChangeId", 'Delete SDP Change worklog')) {
            Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/worklogs/$Id" -Method DELETE
        }
    }
}
