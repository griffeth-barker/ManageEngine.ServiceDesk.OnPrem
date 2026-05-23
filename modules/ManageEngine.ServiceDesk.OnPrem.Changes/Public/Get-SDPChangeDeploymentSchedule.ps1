function Get-SDPChangeDeploymentSchedule {
    <#
    .SYNOPSIS
        Retrieves deployment (downtime) schedules for a ServiceDesk Plus change.
    .PARAMETER ChangeId
        The ID of the parent change.
    .PARAMETER Id
        The ID of a specific deployment schedule to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPChangeDeploymentSchedule -ChangeId '12345'
    .EXAMPLE
        Get-SDPChangeDeploymentSchedule -ChangeId '12345' -Id '1'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPChangeDeploymentSchedule')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$ChangeId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [string]$Id,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes/$Id"
            [SDPChangeDeploymentSchedule]::new($ChangeId, $response.downtime)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes" -InputData @{ list_info = $listInfo }
                foreach ($d in $response.downtimes) { [SDPChangeDeploymentSchedule]::new($ChangeId, $d) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint "changes/$ChangeId/downtimes" -InputData @{ list_info = $listInfo }
            foreach ($d in $response.downtimes) { [SDPChangeDeploymentSchedule]::new($ChangeId, $d) }
        }
    }
}
