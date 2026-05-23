function Remove-SDPChangeTask {
    <#
    .SYNOPSIS
        Deletes a task from a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the task to delete.
    .EXAMPLE
        Remove-SDPChangeTask -ChangeId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Task $Id on Change $ChangeId", 'Delete SDP Change task')) {
            Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/tasks/$Id" -Method DELETE
        }
    }
}
