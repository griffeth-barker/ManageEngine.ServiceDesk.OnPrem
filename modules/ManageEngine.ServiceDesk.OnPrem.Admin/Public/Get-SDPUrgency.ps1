function Get-SDPUrgency {
    <#
    .SYNOPSIS
        Retrieves one or more urgencys from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the urgency to retrieve.
    .PARAMETER PageSize
        Number of records per page (1-100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPUrgency -Id '1'
    .EXAMPLE
        Get-SDPUrgency -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPReference')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
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
            $response = Invoke-SDPRestMethod -Endpoint "urgencies/$Id"
            [SDPReference]::new($response.urgency)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'urgencies' -InputData @{ list_info = $listInfo }
                foreach ($r in $response.urgencies) { [SDPReference]::new($r) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'urgencies' -InputData @{ list_info = $listInfo }
            foreach ($r in $response.urgencies) { [SDPReference]::new($r) }
        }
    }
}
