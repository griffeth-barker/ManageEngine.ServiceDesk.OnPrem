function Convert-SDPTechnicianToUser {
    <#
    .SYNOPSIS
        Converts one or more technicians to regular users (requesters) in ServiceDesk Plus.
    .PARAMETER Id
        One or more technician IDs to convert.
    .EXAMPLE
        Convert-SDPTechnicianToUser -Id '12345'
    .EXAMPLE
        Convert-SDPTechnicianToUser -Id '111','222','333'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id
    )

    process {
        $ids = $Id -join ','
        if ($PSCmdlet.ShouldProcess("Technician(s) $ids", 'Convert SDP Technician(s) to User')) {
            Invoke-SDPRestMethod -Endpoint "technicians/change_as_user?ids=$ids" -Method PUT
        }
    }
}
