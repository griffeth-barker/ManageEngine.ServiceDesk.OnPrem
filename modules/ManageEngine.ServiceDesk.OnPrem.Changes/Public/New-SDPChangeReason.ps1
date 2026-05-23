function New-SDPChangeReason {
    <#
    .SYNOPSIS
        Creates a new reason for change in ServiceDesk Plus.
    .PARAMETER Name
        Name of the reason for change.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeReason -Name 'Compliance requirement'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{ name = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change reason')) {
        $response = Invoke-SDPRestMethod -Endpoint 'reasons_for_change' -Method POST -Body @{ reason_for_change = $body }
        [SDPReference]::new($response.reason_for_change)
    }
}
