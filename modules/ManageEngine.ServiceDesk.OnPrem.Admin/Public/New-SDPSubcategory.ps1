function New-SDPSubcategory {
    <#
    .SYNOPSIS
        Creates a new subcategory in ServiceDesk Plus.
    .PARAMETER Name
        Name of the subcategory.
    .PARAMETER Description
        Description of the subcategory.
    .PARAMETER CategoryId
        ID of the parent category.
    .EXAMPLE
        New-SDPSubcategory -Name 'Laptop' -CategoryId '10'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPSubcategory')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$CategoryId,

        [Parameter()]
        [string]$Description
    )

    $body = @{
        name     = $Name
        category = @{ id = $CategoryId }
    }

    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Subcategory')) {
        $response = Invoke-SDPRestMethod -Endpoint 'subcategories' -Method POST -Body @{ subcategory = $body }
        [SDPSubcategory]::new($response.subcategory)
    }
}
