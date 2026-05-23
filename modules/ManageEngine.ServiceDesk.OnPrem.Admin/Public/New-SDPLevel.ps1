function New-SDPLevel {
    <#
    .SYNOPSIS
        Creates a new level in ServiceDesk Plus.
    .PARAMETER Name
        Name of the level.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPLevel -Name 'Custom Level'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Level')) {
        $response = Invoke-SDPRestMethod -Endpoint 'levels' -Method POST -Body @{ level = $body }
        [SDPReference]::new($response.level)
    }
}
