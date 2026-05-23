function Set-SDPCategory {
    <#
    .SYNOPSIS
        Updates an existing category in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the category to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .PARAMETER TechnicianId
        ID of the default technician.
    .EXAMPLE
        Set-SDPCategory -Id '10' -Description 'Hardware and peripheral requests'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPCategory')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$TechnicianId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))         { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description'))  { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('TechnicianId')) { $body['technician']  = @{ id = $TechnicianId } }

        if ($PSCmdlet.ShouldProcess("Category $Id", 'Update SDP Category')) {
            $response = Invoke-SDPRestMethod -Endpoint "categories/$Id" -Method PUT -Body @{ category = $body }
            [SDPCategory]::new($response.category)
        }
    }
}
