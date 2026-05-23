function Get-SDPItem {
    <#
    .SYNOPSIS
        Retrieves one or more items from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the item to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPItem -Id '100'
    .EXAMPLE
        Get-SDPItem -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPItem')]
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
            $response = Invoke-SDPRestMethod -Endpoint "items/$Id"
            [SDPItem]::new($response.item)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'items' -InputData @{ list_info = $listInfo }
                foreach ($i in $response.items) { [SDPItem]::new($i) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'items' -InputData @{ list_info = $listInfo }
            foreach ($i in $response.items) { [SDPItem]::new($i) }
        }
    }
}
