function Set-SDPSupportGroup {
    <#
    .SYNOPSIS
        Updates an existing support group in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the support group to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .PARAMETER SiteId
        ID of the site to associate.
    .PARAMETER TechnicianIds
        IDs of technicians to set as members (replaces current member list).
    .EXAMPLE
        Set-SDPSupportGroup -Id '7' -Description 'Network and infrastructure team'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSupportGroup')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$SiteId,

        [Parameter()]
        [string[]]$TechnicianIds
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))          { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description'))   { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('SiteId'))        { $body['site']        = @{ id = $SiteId } }
        if ($PSBoundParameters.ContainsKey('TechnicianIds')) {
            $body['technicians'] = @($TechnicianIds | ForEach-Object { @{ id = $_ } })
        }

        if ($PSCmdlet.ShouldProcess("Support Group $Id", 'Update SDP Support Group')) {
            $response = Invoke-SDPRestMethod -Endpoint "support_groups/$Id" -Method PUT -Body @{ support_group = $body }
            [SDPSupportGroup]::new($response.support_group)
        }
    }
}
