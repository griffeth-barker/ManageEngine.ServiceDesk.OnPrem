function New-SDPPriorityMatrix {
    <#
    .SYNOPSIS
        Adds an entry to the priority matrix in ServiceDesk Plus.
    .DESCRIPTION
        Maps an urgency + impact combination to a resulting priority.
    .PARAMETER UrgencyId
        ID of the urgency.
    .PARAMETER ImpactId
        ID of the impact.
    .PARAMETER PriorityId
        ID of the resulting priority.
    .EXAMPLE
        New-SDPPriorityMatrix -UrgencyId '1' -ImpactId '1' -PriorityId '4'
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

    if ($PSCmdlet.ShouldProcess("Urgency=$UrgencyId Impact=$ImpactId → Priority=$PriorityId", 'Add SDP Priority Matrix entry')) {
        Invoke-SDPRestMethod -Endpoint 'priority_matrices' -Method POST -Body @{ priority_matrix = $body }
    }
}
