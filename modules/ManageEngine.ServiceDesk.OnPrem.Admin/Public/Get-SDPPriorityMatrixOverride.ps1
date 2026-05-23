function Get-SDPPriorityMatrixOverride {
    <#
    .SYNOPSIS
        Gets whether the Allow Override option is enabled in the priority matrix.
    .EXAMPLE
        Get-SDPPriorityMatrixOverride
    #>
    [CmdletBinding()]
    param()

    $response = Invoke-SDPRestMethod -Endpoint 'priority_matrices/_allow_override'
    $response.priority_matrix
}
