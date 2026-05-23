function Get-SDPChangeReason {
    <#
    .SYNOPSIS
        Retrieves one or more change reasons from ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change reason to retrieve.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPChangeReason
    .EXAMPLE
        Get-SDPChangeReason -Id '1'
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
            $response = Invoke-SDPRestMethod -Endpoint "reasons_for_change/$Id"
            [SDPReference]::new($response.reason_for_change)
            return
        }

        $listInfo = @{ row_count = $PageSize }

        if ($All) {
            $index = $StartIndex
            do {
                $listInfo['start_index'] = $index
                $response = Invoke-SDPRestMethod -Endpoint 'reasons_for_change' -InputData @{ list_info = $listInfo }
                foreach ($r in $response.reasons_for_change) { [SDPReference]::new($r) }
                $index += $PageSize
            } while ($response.list_info.has_more_rows)
        } else {
            $listInfo['start_index'] = $StartIndex
            $response = Invoke-SDPRestMethod -Endpoint 'reasons_for_change' -InputData @{ list_info = $listInfo }
            foreach ($r in $response.reasons_for_change) { [SDPReference]::new($r) }
        }
    }
}
