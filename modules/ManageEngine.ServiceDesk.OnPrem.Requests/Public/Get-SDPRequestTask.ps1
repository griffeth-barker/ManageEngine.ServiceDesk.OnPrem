function Get-SDPRequestTask {
    <#
    .SYNOPSIS
        Retrieves tasks for a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the parent request.
    .PARAMETER Id
        The ID of a specific task to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPRequestTask -RequestId '12345'
    .EXAMPLE
        Get-SDPRequestTask -RequestId '12345' -Id '1'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPRequestTask')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

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
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks/$Id"
            [SDPRequestTask]::new($RequestId, $response.task)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks" -InputData @{ list_info = $listInfo }
                foreach ($t in $response.tasks) { [SDPRequestTask]::new($RequestId, $t) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/tasks" -InputData @{ list_info = $listInfo }
            foreach ($t in $response.tasks) { [SDPRequestTask]::new($RequestId, $t) }
        }
    }
}
