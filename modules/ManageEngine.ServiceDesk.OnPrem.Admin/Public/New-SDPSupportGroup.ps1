function New-SDPSupportGroup {
    <#
    .SYNOPSIS
        Creates a new support group in ServiceDesk Plus.
    .PARAMETER Name
        Name of the support group.
    .PARAMETER Description
        Description of the support group.
    .PARAMETER SiteId
        ID of the site to associate.
    .PARAMETER TechnicianIds
        IDs of technicians to add as members.
    .EXAMPLE
        New-SDPSupportGroup -Name 'Network Team' -Description 'Handles network issues'
    .EXAMPLE
        New-SDPSupportGroup -Name 'Helpdesk' -TechnicianIds '5','6','7'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSupportGroup')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$SiteId,

        [Parameter()]
        [string[]]$TechnicianIds
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('Description'))   { $body['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('SiteId'))        { $body['site']        = @{ id = $SiteId } }
    if ($PSBoundParameters.ContainsKey('TechnicianIds')) {
        $body['technicians'] = @($TechnicianIds | ForEach-Object { @{ id = $_ } })
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Support Group')) {
        $response = Invoke-SDPRestMethod -Endpoint 'support_groups' -Method POST -Body @{ support_group = $body }
        [SDPSupportGroup]::new($response.support_group)
    }
}
