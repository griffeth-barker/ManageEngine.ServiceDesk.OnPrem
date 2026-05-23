function Set-SDPChangeRole {
    <#
    .SYNOPSIS
        Updates a change role in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change role to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeRole -Id '1' -Name 'CAB Member'
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

    if ($PSCmdlet.ShouldProcess("Change role $Id", 'Update SDP Change role')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_roles/$Id" -Method PUT -Body @{ change_role = $body }
        [SDPReference]::new($response.change_role)
    }
}
