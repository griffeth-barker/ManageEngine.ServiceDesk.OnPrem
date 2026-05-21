function Get-SDPApproval {
    <#
    .SYNOPSIS
        Retrieves pending approvals from ServiceDesk Plus.
    .DESCRIPTION
        Returns approvals that are awaiting action. This is a global list across all requests,
        not scoped to a single request.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .PARAMETER All
        Automatically pages through all results.
    .EXAMPLE
        Get-SDPApproval
    .EXAMPLE
        Get-SDPApproval -All
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter()]
        [int]$StartIndex = 1,

        [Parameter()]
        [switch]$All
    )

    $listInfo = @{ row_count = $PageSize }

    if ($All) {
        $index = $StartIndex
        do {
            $listInfo['start_index'] = $index
            $response = Invoke-SDPRestMethod -Endpoint 'approvals' -InputData @{ list_info = $listInfo }
            $response.approvals
            $index += $PageSize
        } while ($response.list_info.has_more_rows)
    } else {
        $listInfo['start_index'] = $StartIndex
        $response = Invoke-SDPRestMethod -Endpoint 'approvals' -InputData @{ list_info = $listInfo }
        $response.approvals
    }
}
