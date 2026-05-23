function Remove-SDPRegion {
    <#
    .SYNOPSIS
        Removes a region from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the region to remove.
    .EXAMPLE
        Remove-SDPRegion -Id '5'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Region $Id", 'Remove SDP Region')) {
            Invoke-SDPRestMethod -Endpoint "regions/$Id" -Method DELETE
        }
    }
}
