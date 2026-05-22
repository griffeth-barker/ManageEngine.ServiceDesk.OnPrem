function Remove-SDPRequestWorklog {
    <#
    .SYNOPSIS
        Deletes a worklog entry from a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of the worklog to delete.
    .EXAMPLE
        Remove-SDPRequestWorklog -RequestId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Worklog $Id on Request $RequestId", 'Delete SDP Request Worklog')) {
            Invoke-SDPRestMethod -Endpoint "requests/$RequestId/worklogs/$Id" -Method DELETE
        }
    }
}
