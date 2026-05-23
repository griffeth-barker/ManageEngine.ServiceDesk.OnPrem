function Set-SDPChangeRisk {
    <#
    .SYNOPSIS
        Updates a risk level in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the risk to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeRisk -Id '1' -Name 'Medium'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess("Risk $Id", 'Update SDP Change risk')) {
        $response = Invoke-SDPRestMethod -Endpoint "risks/$Id" -Method PUT -Body @{ risk = $body }
        [SDPReference]::new($response.risk)
    }
}
