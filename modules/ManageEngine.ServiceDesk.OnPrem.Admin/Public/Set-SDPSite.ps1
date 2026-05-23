function Set-SDPSite {
    <#
    .SYNOPSIS
        Updates an existing site in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the site to update.
    .PARAMETER Name
        New name for the site.
    .PARAMETER Description
        New description.
    .PARAMETER EmailId
        Contact email address.
    .PARAMETER City
        City.
    .PARAMETER State
        State or province.
    .PARAMETER Country
        Country.
    .PARAMETER RegionId
        ID of the region to associate.
    .EXAMPLE
        Set-SDPSite -Id '3' -Description 'Primary US headquarters'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSite')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$EmailId,

        [Parameter()]
        [string]$City,

        [Parameter()]
        [string]$State,

        [Parameter()]
        [string]$Country,

        [Parameter()]
        [string]$RegionId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('EmailId'))     { $body['email_id']    = $EmailId }
        if ($PSBoundParameters.ContainsKey('City'))        { $body['city']        = $City }
        if ($PSBoundParameters.ContainsKey('State'))       { $body['state']       = $State }
        if ($PSBoundParameters.ContainsKey('Country'))     { $body['country']     = $Country }
        if ($PSBoundParameters.ContainsKey('RegionId'))    { $body['region']      = @{ id = $RegionId } }

        if ($PSCmdlet.ShouldProcess("Site $Id", 'Update SDP Site')) {
            $response = Invoke-SDPRestMethod -Endpoint "sites/$Id" -Method PUT -Body @{ site = $body }
            [SDPSite]::new($response.site)
        }
    }
}
