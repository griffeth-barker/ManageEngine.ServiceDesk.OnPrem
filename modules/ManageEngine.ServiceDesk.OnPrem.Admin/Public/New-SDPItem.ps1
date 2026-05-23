function New-SDPItem {
    <#
    .SYNOPSIS
        Creates a new item in ServiceDesk Plus.
    .PARAMETER Name
        Name of the item.
    .PARAMETER Description
        Description of the item.
    .PARAMETER SubcategoryId
        ID of the parent subcategory.
    .EXAMPLE
        New-SDPItem -Name 'Dell Latitude' -SubcategoryId '50'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPItem')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$SubcategoryId,

        [Parameter()]
        [string]$Description
    )

    $body = @{
        name        = $Name
        subcategory = @{ id = $SubcategoryId }
    }

    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Item')) {
        $response = Invoke-SDPRestMethod -Endpoint 'items' -Method POST -Body @{ item = $body }
        [SDPItem]::new($response.item)
    }
}
