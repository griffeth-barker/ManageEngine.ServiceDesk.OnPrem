function Invoke-SDPProblemPickup {
    <#
    .SYNOPSIS
        Picks up one or more problems in ServiceDesk Plus, assigning them to the current technician.
    .PARAMETER Id
        One or more problem IDs to pick up.
    .EXAMPLE
        Invoke-SDPProblemPickup -Id '12345'
    .EXAMPLE
        Get-SDPProblem -Filter @(@{ field = 'status.name'; condition = 'is'; value = 'Open' }) | Invoke-SDPProblemPickup
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id
    )

    process {
        foreach ($problemId in $Id) {
            if ($PSCmdlet.ShouldProcess("Problem $problemId", 'Pickup SDP Problem')) {
                Invoke-SDPRestMethod -Endpoint "problems/$problemId/pickup" -Method PUT
            }
        }
    }
}
