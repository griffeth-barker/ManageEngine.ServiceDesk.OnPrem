function Set-SDPPriorityMatrixOverride {
    <#
    .SYNOPSIS
        Sets whether the Allow Override option is enabled in the priority matrix.
    .PARAMETER AllowOverride
        When $true, technicians can override the auto-calculated priority.
    .EXAMPLE
        Set-SDPPriorityMatrixOverride -AllowOverride $true
    .EXAMPLE
        Set-SDPPriorityMatrixOverride -AllowOverride $false
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [bool]$AllowOverride
    )

    if ($PSCmdlet.ShouldProcess("AllowOverride=$AllowOverride", 'Update SDP Priority Matrix Override setting')) {
        Invoke-SDPRestMethod -Endpoint 'priority_matrices/_allow_override' -Method PUT -Body @{
            priority_matrix = @{ allow_override = $AllowOverride }
        }
    }
}
