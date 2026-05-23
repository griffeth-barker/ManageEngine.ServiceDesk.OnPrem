function New-SDPSite {
    <#
    .SYNOPSIS
        Creates a new site in ServiceDesk Plus.
    .PARAMETER Name
        Name of the site.
    .PARAMETER Description
        Description of the site.
    .PARAMETER EmailId
        Contact email address for the site.
    .PARAMETER City
        City where the site is located.
    .PARAMETER State
        State or province.
    .PARAMETER Country
        Country.
    .PARAMETER RegionId
        ID of the region to associate this site with.
    .EXAMPLE
        New-SDPSite -Name 'Austin HQ' -City 'Austin' -State 'TX' -Country 'USA'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSite')]
    param(
        [Parameter(Mandatory)]
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

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('EmailId'))     { $body['email_id']    = $EmailId }
    if ($PSBoundParameters.ContainsKey('City'))        { $body['city']        = $City }
    if ($PSBoundParameters.ContainsKey('State'))       { $body['state']       = $State }
    if ($PSBoundParameters.ContainsKey('Country'))     { $body['country']     = $Country }
    if ($PSBoundParameters.ContainsKey('RegionId'))    { $body['region']      = @{ id = $RegionId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Site')) {
        $response = Invoke-SDPRestMethod -Endpoint 'sites' -Method POST -Body @{ site = $body }
        [SDPSite]::new($response.site)
    }
}
