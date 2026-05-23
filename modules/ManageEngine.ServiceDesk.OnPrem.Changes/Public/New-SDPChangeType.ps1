function New-SDPChangeType {
    <#
    .SYNOPSIS
        Creates a new change type in ServiceDesk Plus.
    .PARAMETER Name
        Name of the change type.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeType -Name 'Emergency'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change type')) {
        $response = Invoke-SDPRestMethod -Endpoint 'change_types' -Method POST -Body @{ change_type = $body }
        [SDPReference]::new($response.change_type)
    }
}
