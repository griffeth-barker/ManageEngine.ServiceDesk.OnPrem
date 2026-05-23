function Get-SDPDepartment {
    <#
    .SYNOPSIS
        Retrieves one or more departments from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the department to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index for the page. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results and returns every department.
    .EXAMPLE
        Get-SDPDepartment -Id '2'
    .EXAMPLE
        Get-SDPDepartment -All
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    [OutputType('SDPDepartment')]
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
            $response = Invoke-SDPRestMethod -Endpoint "departments/$Id"
            [SDPDepartment]::new($response.department)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'departments' -InputData @{ list_info = $listInfo }
                foreach ($d in $response.departments) { [SDPDepartment]::new($d) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'departments' -InputData @{ list_info = $listInfo }
            foreach ($d in $response.departments) { [SDPDepartment]::new($d) }
        }
    }
}
