function Get-SDPSubcategory {
    <#
    .SYNOPSIS
        Retrieves one or more subcategories from ServiceDesk Plus.
    .DESCRIPTION
        Use the Id parameter set to fetch a single subcategory by its ID.
        Use the List parameter set to retrieve all subcategories under a parent category (CategoryId is required).
    .PARAMETER Id
        The ID of the subcategory to retrieve.
    .PARAMETER CategoryId
        The ID of the parent category whose subcategories to list.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPSubcategory -Id '50'
    .EXAMPLE
        Get-SDPSubcategory -CategoryId '10' -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPSubcategory')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter(Mandatory, ParameterSetName = 'List')]
        [string]$CategoryId,

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
            $response = Invoke-SDPRestMethod -Endpoint "subcategories/$Id"
            [SDPSubcategory]::new($response.subcategory)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint "categories/$CategoryId/subcategories" -InputData @{ list_info = $listInfo }
                foreach ($s in $response.subcategories) { [SDPSubcategory]::new($s) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint "categories/$CategoryId/subcategories" -InputData @{ list_info = $listInfo }
            foreach ($s in $response.subcategories) { [SDPSubcategory]::new($s) }
        }
    }
}
