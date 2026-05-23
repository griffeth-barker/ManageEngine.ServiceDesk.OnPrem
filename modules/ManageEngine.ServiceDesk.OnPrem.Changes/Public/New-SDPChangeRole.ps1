function New-SDPChangeRole {
    <#
    .SYNOPSIS
        Creates a new change role in ServiceDesk Plus.
    .PARAMETER Name
        Name of the change role.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeRole -Name 'Change Manager'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change role')) {
        $response = Invoke-SDPRestMethod -Endpoint 'change_roles' -Method POST -Body @{ change_role = $body }
        [SDPReference]::new($response.change_role)
    }
}
