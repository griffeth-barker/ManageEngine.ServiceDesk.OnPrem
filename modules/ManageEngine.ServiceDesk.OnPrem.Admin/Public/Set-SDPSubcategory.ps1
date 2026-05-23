function Set-SDPSubcategory {
    <#
    .SYNOPSIS
        Updates an existing subcategory in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the subcategory to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .PARAMETER CategoryId
        ID of the parent category (to move to a different category).
    .EXAMPLE
        Set-SDPSubcategory -Id '50' -Description 'Laptop hardware issues'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSubcategory')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$CategoryId
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }
        if ($PSBoundParameters.ContainsKey('CategoryId'))  { $body['category']    = @{ id = $CategoryId } }

        if ($PSCmdlet.ShouldProcess("Subcategory $Id", 'Update SDP Subcategory')) {
            $response = Invoke-SDPRestMethod -Endpoint "subcategories/$Id" -Method PUT -Body @{ subcategory = $body }
            [SDPSubcategory]::new($response.subcategory)
        }
    }
}
