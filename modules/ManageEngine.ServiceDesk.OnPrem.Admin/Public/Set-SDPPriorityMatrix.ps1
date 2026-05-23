function Set-SDPPriorityMatrix {
    <#
    .SYNOPSIS
        Updates an entry in the priority matrix in ServiceDesk Plus.
    .PARAMETER UrgencyId
        ID of the urgency for the entry to update.
    .PARAMETER ImpactId
        ID of the impact for the entry to update.
    .PARAMETER PriorityId
        ID of the new resulting priority.
    .EXAMPLE
        Set-SDPPriorityMatrix -UrgencyId '1' -ImpactId '1' -PriorityId '3'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$UrgencyId,

        [Parameter(Mandatory)]
        [string]$ImpactId,

        [Parameter(Mandatory)]
        [string]$PriorityId
    )

    $body = @{
        urgency  = @{ id = $UrgencyId }
        impact   = @{ id = $ImpactId }
        priority = @{ id = $PriorityId }
    }

    if ($PSCmdlet.ShouldProcess("Urgency=$UrgencyId Impact=$ImpactId", 'Update SDP Priority Matrix entry')) {
        Invoke-SDPRestMethod -Endpoint 'priority_matrices' -Method PUT -Body @{ priority_matrix = $body }
    }
}
