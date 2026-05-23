function Set-SDPChangeReason {
    <#
    .SYNOPSIS
        Updates a reason for change in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the reason to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeReason -Id '1' -Name 'Security patching'
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

    if ($PSCmdlet.ShouldProcess("Change reason $Id", 'Update SDP Change reason')) {
        $response = Invoke-SDPRestMethod -Endpoint "reasons_for_change/$Id" -Method PUT -Body @{ reason_for_change = $body }
        [SDPReference]::new($response.reason_for_change)
    }
}
