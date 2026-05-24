function Set-SDPProblemAssignment {
    <#
    .SYNOPSIS
        Assigns one or more problems to a technician or group in ServiceDesk Plus.
    .PARAMETER Id
        One or more problem IDs to assign.
    .PARAMETER TechnicianName
        Name of the technician to assign.
    .PARAMETER GroupName
        Name of the group to assign.
    .EXAMPLE
        Set-SDPProblemAssignment -Id '12345' -TechnicianName 'Bob Jones'
    .EXAMPLE
        Set-SDPProblemAssignment -Id '12345','67890' -GroupName 'Problem Management'
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
        $body = @{}
        if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician'] = @{ name = $TechnicianName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))      { $body['group']      = @{ name = $GroupName } }

        foreach ($problemId in $Id) {
            if ($PSCmdlet.ShouldProcess("Problem $problemId", 'Assign SDP Problem')) {
                $params = @{ Endpoint = "problems/$problemId/assign"; Method = 'PUT' }
                if ($body.Count -gt 0) { $params['Body'] = @{ problem = $body } }
                Invoke-SDPRestMethod @params
            }
        }
    }
}
