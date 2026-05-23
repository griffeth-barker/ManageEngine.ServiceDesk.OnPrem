function New-SDPMode {
    <#
    .SYNOPSIS
        Creates a new mode in ServiceDesk Plus.
    .PARAMETER Name
        Name of the mode.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPMode -Name 'Custom Mode'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Mode')) {
        $response = Invoke-SDPRestMethod -Endpoint 'modes' -Method POST -Body @{ mode = $body }
        [SDPReference]::new($response.mode)
    }
}
