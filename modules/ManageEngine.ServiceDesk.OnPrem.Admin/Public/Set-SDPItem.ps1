function Set-SDPItem {
    <#
    .SYNOPSIS
        Updates an existing item in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the item to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .PARAMETER SubcategoryId
        ID of the parent subcategory.
    .EXAMPLE
        Set-SDPItem -Id '100' -Description 'Dell Latitude 14-inch laptop'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPItem')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$SubcategoryId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))          { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description'))   { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('SubcategoryId')) { $body['subcategory'] = @{ id = $SubcategoryId } }

        if ($PSCmdlet.ShouldProcess("Item $Id", 'Update SDP Item')) {
            $response = Invoke-SDPRestMethod -Endpoint "items/$Id" -Method PUT -Body @{ item = $body }
            [SDPItem]::new($response.item)
        }
    }
}
