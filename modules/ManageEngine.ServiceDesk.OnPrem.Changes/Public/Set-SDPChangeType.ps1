function Set-SDPChangeType {
    <#
    .SYNOPSIS
        Updates a change type in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change type to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeType -Id '1' -Name 'Standard'
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

    if ($PSCmdlet.ShouldProcess("Change type $Id", 'Update SDP Change type')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_types/$Id" -Method PUT -Body @{ change_type = $body }
        [SDPReference]::new($response.change_type)
    }
}
