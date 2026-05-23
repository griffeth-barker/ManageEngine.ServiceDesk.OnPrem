function New-SDPImpact {
    <#
    .SYNOPSIS
        Creates a new impact in ServiceDesk Plus.
    .PARAMETER Name
        Name of the impact.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPImpact -Name 'Custom Impact'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReference')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{ name = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Impact')) {
        $response = Invoke-SDPRestMethod -Endpoint 'impacts' -Method POST -Body @{ impact = $body }
        [SDPReference]::new($response.impact)
    }
}
