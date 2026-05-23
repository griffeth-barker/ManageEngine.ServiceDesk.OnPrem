function Set-SDPChangeAssignment {
    <#
    .SYNOPSIS
        Assigns one or more changes to a technician or group in ServiceDesk Plus.
    .PARAMETER Id
        One or more change IDs to assign.
    .PARAMETER TechnicianName
        Name of the technician to assign.
    .PARAMETER GroupName
        Name of the group to assign.
    .EXAMPLE
        Set-SDPChangeAssignment -Id '12345' -TechnicianName 'Bob Jones'
    .EXAMPLE
        Set-SDPChangeAssignment -Id '12345','67890' -GroupName 'Change Management'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id,

        [Parameter()]
        [string]$TechnicianName,

        [Parameter()]
        [string]$GroupName
    )

    process {
        $idsParam = $Id -join ','

        $body = @{}
        if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician'] = @{ name = $TechnicianName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))      { $body['group']      = @{ name = $GroupName } }

        if ($PSCmdlet.ShouldProcess("Change(s) $idsParam", 'Assign SDP Change(s)')) {
            $params = @{
                Endpoint = "changes/assign?ids=$idsParam"
                Method   = 'PUT'
            }
            if ($body.Count -gt 0) { $params['Body'] = @{ change = $body } }
            Invoke-SDPRestMethod @params
        }
    }
}
