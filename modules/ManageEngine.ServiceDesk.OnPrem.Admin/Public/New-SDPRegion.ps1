function New-SDPRegion {
    <#
    .SYNOPSIS
        Creates a new region in ServiceDesk Plus.
    .PARAMETER Name
        Name of the region.
    .PARAMETER Description
        Description of the region.
    .EXAMPLE
        New-SDPRegion -Name 'North America' -Description 'US and Canada offices'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRegion')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{ name = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Region')) {
        $response = Invoke-SDPRestMethod -Endpoint 'regions' -Method POST -Body @{ region = $body }
        [SDPRegion]::new($response.region)
    }
}
