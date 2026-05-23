function Get-SDPChangeStatus {
    <#
    .SYNOPSIS
        Retrieves one or more change statuses from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change status to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPChangeStatus
    .EXAMPLE
        Get-SDPChangeStatus -Id '1'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
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
            $response = Invoke-SDPRestMethod -Endpoint "change_statuses/$Id"
            [SDPReference]::new($response.change_status)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'change_statuses' -InputData @{ list_info = $listInfo }
                foreach ($s in $response.change_statuses) { [SDPReference]::new($s) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'change_statuses' -InputData @{ list_info = $listInfo }
            foreach ($s in $response.change_statuses) { [SDPReference]::new($s) }
        }
    }
}
