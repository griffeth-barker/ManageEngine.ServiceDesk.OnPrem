function Set-SDPRegion {
    <#
    .SYNOPSIS
        Updates an existing region in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the region to update.
    .PARAMETER Name
        New name for the region.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPRegion -Id '1' -Description 'US, Canada, and Mexico'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRegion')]
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

        if ($PSCmdlet.ShouldProcess("Region $Id", 'Update SDP Region')) {
            $response = Invoke-SDPRestMethod -Endpoint "regions/$Id" -Method PUT -Body @{ region = $body }
            [SDPRegion]::new($response.region)
        }
    }
}
