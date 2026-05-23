function Set-SDPChangeStage {
    <#
    .SYNOPSIS
        Updates a change stage in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change stage to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeStage -Id '1' -Name 'Planning'
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

    if ($PSCmdlet.ShouldProcess("Change stage $Id", 'Update SDP Change stage')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_stages/$Id" -Method PUT -Body @{ change_stage = $body }
        [SDPReference]::new($response.change_stage)
    }
}
