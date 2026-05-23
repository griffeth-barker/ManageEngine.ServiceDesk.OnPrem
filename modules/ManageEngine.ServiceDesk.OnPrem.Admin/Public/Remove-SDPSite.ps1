function Remove-SDPSite {
    <#
    .SYNOPSIS
        Removes a site from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the site to remove.
    .EXAMPLE
        Remove-SDPSite -Id '5'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Site $Id", 'Remove SDP Site')) {
            Invoke-SDPRestMethod -Endpoint "sites/$Id" -Method DELETE
        }
    }
}
