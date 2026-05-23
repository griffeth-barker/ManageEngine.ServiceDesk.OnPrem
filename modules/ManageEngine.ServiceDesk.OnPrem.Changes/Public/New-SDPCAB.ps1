function New-SDPCAB {
    <#
    .SYNOPSIS
        Creates a new Change Advisory Board (CAB) in ServiceDesk Plus.
    .PARAMETER Name
        Name of the CAB.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPCAB -Name 'IT Change Advisory Board'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP CAB')) {
        $response = Invoke-SDPRestMethod -Endpoint 'cabs' -Method POST -Body @{ cab = $body }
        [SDPReference]::new($response.cab)
    }
}
