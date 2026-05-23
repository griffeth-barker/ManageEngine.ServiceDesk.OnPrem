function Invoke-SDPChangePickup {
    <#
    .SYNOPSIS
        Picks up (self-assigns) one or more changes in ServiceDesk Plus.
    .PARAMETER Id
        One or more change IDs to pick up.
    .EXAMPLE
        Invoke-SDPChangePickup -Id '12345'
    .EXAMPLE
        Invoke-SDPChangePickup -Id '12345','67890'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Id
    )

    process {
        $idsParam = $Id -join ','
        if ($PSCmdlet.ShouldProcess("Change(s) $idsParam", 'Pick up SDP Change(s)')) {
            Invoke-SDPRestMethod -Endpoint "changes/pickup?ids=$idsParam" -Method PUT
        }
    }
}
