function Remove-SDPRequestTask {
    <#
    .SYNOPSIS
        Deletes a task from a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the task to delete.
    .EXAMPLE
        Remove-SDPRequestTask -RequestId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Task $Id on Request $RequestId", 'Delete SDP Request Task')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$Id" -Method DELETE
        }
    }
}
