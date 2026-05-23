function Set-SDPImpact {
    <#
    .SYNOPSIS
        Updates an existing impact in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the impact to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPImpact -Id '1' -Name 'Updated Impact Name'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReference')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

        if ($PSCmdlet.ShouldProcess("Impact $Id", 'Update SDP Impact')) {
            $response = Invoke-SDPRestMethod -Endpoint "impacts/$Id" -Method PUT -Body @{ impact = $body }
            [SDPReference]::new($response.impact)
        }
    }
}
