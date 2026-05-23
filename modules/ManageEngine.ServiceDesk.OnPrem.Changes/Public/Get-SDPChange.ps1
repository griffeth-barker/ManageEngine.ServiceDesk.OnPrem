function Get-SDPChange {
    <#
    .SYNOPSIS
        Retrieves one or more changes from ServiceDesk Plus.
    .DESCRIPTION
        Use the Id parameter set to fetch a single change by ID.
        Use the List parameter set (default) to retrieve a paged list, optionally filtered and sorted.
    .PARAMETER Id
        The ID of the change to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER SortField
        Field name to sort by (e.g. 'created_time', 'title').
    .PARAMETER SortOrder
        Sort direction: 'asc' or 'desc'.
    .PARAMETER Filter
        An array of search criteria hashtables. Each hashtable should contain 'field', 'value',
        'condition' (e.g. 'contains', 'eq'), and optionally 'logical_operator' ('and'/'or').
    .PARAMETER All
        Automatically pages through all results and returns every change matching the criteria.
    .EXAMPLE
        Get-SDPChange -Id '12345'
    .EXAMPLE
        Get-SDPChange -All
    .EXAMPLE
        Get-SDPChange -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' })
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPChange')]
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
        [hashtable[]]$Filter,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$Id"
            [SDPChange]::new($response.change)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($SortField) { $listInfo['sort_field']      = $SortField }
        if ($SortOrder) { $listInfo['sort_order']      = $SortOrder }
        if ($Filter)    { $listInfo['search_criteria']  = $Filter }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'changes' -InputData @{ list_info = $listInfo }
                foreach ($c in $response.changes) { [SDPChange]::new($c) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'changes' -InputData @{ list_info = $listInfo }
            foreach ($c in $response.changes) { [SDPChange]::new($c) }
        }
    }
}
