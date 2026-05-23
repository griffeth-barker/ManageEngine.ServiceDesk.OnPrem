function Set-SDPCAB {
    <#
    .SYNOPSIS
        Updates a Change Advisory Board (CAB) in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the CAB to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPCAB -Id '1' -Name 'Enterprise CAB'
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

    if ($PSCmdlet.ShouldProcess("CAB $Id", 'Update SDP CAB')) {
        $response = Invoke-SDPRestMethod -Endpoint "cabs/$Id" -Method PUT -Body @{ cab = $body }
        [SDPReference]::new($response.cab)
    }
}
