function Get-SDPTechnician {
    <#
    .SYNOPSIS
        Retrieves one or more technicians from ServiceDesk Plus.
    .DESCRIPTION
        Use the Id parameter set to fetch a single technician by ID.
        Use the List parameter set (default) to retrieve a paged list, optionally sorted.
    .PARAMETER Id
        The ID of the technician to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER SortField
        Field name to sort by (e.g. 'name').
    .PARAMETER SortOrder
        Sort direction: 'asc' or 'desc'.
    .PARAMETER All
        Automatically pages through all results and returns every technician.
    .EXAMPLE
        Get-SDPTechnician -Id '12345'
    .EXAMPLE
        Get-SDPTechnician -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPTechnician')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter(ParameterSetName = 'List')]
        [int]$StartIndex = 1,

        [Parameter(ParameterSetName = 'List')]
        [string]$SortField,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('asc', 'desc')]
        [string]$SortOrder,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "technicians/$Id"
            [SDPTechnician]::new($response.technician)
            return
        }

        $listInfo = @{ row_count = $PageSize }
        if ($SortField) { $listInfo['sort_field'] = $SortField }
        if ($SortOrder) { $listInfo['sort_order'] = $SortOrder }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'technicians' -InputData @{ list_info = $listInfo }
                foreach ($t in $response.technicians) { [SDPTechnician]::new($t) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'technicians' -InputData @{ list_info = $listInfo }
            foreach ($t in $response.technicians) { [SDPTechnician]::new($t) }
        }
    }
}
