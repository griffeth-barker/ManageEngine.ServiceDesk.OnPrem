function Get-SDPCAB {
    <#
    .SYNOPSIS
        Retrieves one or more Change Advisory Boards (CABs) from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the CAB to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPCAB
    .EXAMPLE
        Get-SDPCAB -Id '1'
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
            $response = Invoke-SDPRestMethod -Endpoint "cabs/$Id"
            [SDPReference]::new($response.cab)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'cabs' -InputData @{ list_info = $listInfo }
                foreach ($c in $response.cabs) { [SDPReference]::new($c) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'cabs' -InputData @{ list_info = $listInfo }
            foreach ($c in $response.cabs) { [SDPReference]::new($c) }
        }
    }
}
