function Remove-SDPRequest {
    <#
    .SYNOPSIS
        Deletes a request from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the request to delete.
    .EXAMPLE
        Remove-SDPRequest -Id '12345'
    .EXAMPLE
        Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Cancelled' }) -All |
            Remove-SDPRequest
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Request $Id", 'Delete SDP Request')) {
            Invoke-SDPRestMethod -Endpoint "requests/$Id" -Method DELETE
        }
    }
}
