function Remove-SDPDepartment {
    <#
    .SYNOPSIS
        Removes one or more departments from ServiceDesk Plus.
    .DESCRIPTION
        The API requires department IDs to be passed as a comma-separated list.
        Accepts a single ID or multiple IDs.
    .PARAMETER Id
        One or more department IDs to remove.
    .EXAMPLE
        Remove-SDPDepartment -Id '12345'
    .EXAMPLE
        Remove-SDPDepartment -Id '111','222'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id
    )

    process {
        $ids = $Id -join ','
        if ($PSCmdlet.ShouldProcess("Department(s) $ids", 'Remove SDP Department(s)')) {
            Invoke-SDPRestMethod -Endpoint "departments?ids=$ids" -Method DELETE
        }
    }
}
