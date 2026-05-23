function Remove-SDPChangeDeploymentSchedule {
    <#
    .SYNOPSIS
        Deletes a deployment (downtime) schedule from a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of the deployment schedule to delete.
    .EXAMPLE
        Remove-SDPChangeDeploymentSchedule -ChangeId '12345' -Id '1'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Deployment schedule $Id on Change $ChangeId", 'Delete SDP Change deployment schedule')) {
            Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes/$Id" -Method DELETE
        }
    }
}
