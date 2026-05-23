function Remove-SDPPriorityMatrix {
    <#
    .SYNOPSIS
        Removes an entry from the priority matrix in ServiceDesk Plus.
    .PARAMETER UrgencyId
        ID of the urgency for the entry to remove.
    .PARAMETER ImpactId
        ID of the impact for the entry to remove.
    .EXAMPLE
        Remove-SDPPriorityMatrix -UrgencyId '1' -ImpactId '3'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)]
        [string]$UrgencyId,

        [Parameter(Mandatory)]
        [string]$ImpactId
    )

    $body = @{
        urgency = @{ id = $UrgencyId }
        impact  = @{ id = $ImpactId }
    }

    if ($PSCmdlet.ShouldProcess("Urgency=$UrgencyId Impact=$ImpactId", 'Remove SDP Priority Matrix entry')) {
        Invoke-SDPRestMethod -Endpoint 'priority_matrices' -Method DELETE -Body @{ priority_matrix = $body }
    }
}
