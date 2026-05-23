function New-SDPChangeRisk {
    <#
    .SYNOPSIS
        Creates a new risk level in ServiceDesk Plus.
    .PARAMETER Name
        Name of the risk.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeRisk -Name 'High'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change risk')) {
        $response = Invoke-SDPRestMethod -Endpoint 'risks' -Method POST -Body @{ risk = $body }
        [SDPReference]::new($response.risk)
    }
}
