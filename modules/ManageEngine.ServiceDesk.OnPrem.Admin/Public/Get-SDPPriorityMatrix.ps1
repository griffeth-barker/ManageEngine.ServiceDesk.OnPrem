function Get-SDPPriorityMatrix {
    <#
    .SYNOPSIS
        Retrieves the priority matrix entries from ServiceDesk Plus.
    .DESCRIPTION
        The priority matrix maps urgency + impact combinations to a resulting priority.
    .PARAMETER PageSize
        Number of records per page (1–100). Defaults to 100.
    .PARAMETER StartIndex
        1-based starting index. Defaults to 1.
    .EXAMPLE
        Get-SDPPriorityMatrix
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$PageSize = 100,

        [Parameter()]
        [int]$StartIndex = 1
    )

    $listInfo = @{ row_count = $PageSize; start_index = $StartIndex }
    $response = Invoke-SDPRestMethod -Endpoint 'priority_matrices' -InputData @{ list_info = $listInfo }
    $response.priority_matrices
}
