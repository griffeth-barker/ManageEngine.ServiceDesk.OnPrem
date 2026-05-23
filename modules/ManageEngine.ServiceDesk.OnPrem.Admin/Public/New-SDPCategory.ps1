function New-SDPCategory {
    <#
    .SYNOPSIS
        Creates a new category in ServiceDesk Plus.
    .PARAMETER Name
        Name of the category.
    .PARAMETER Description
        Description of the category.
    .PARAMETER TechnicianId
        ID of the default technician for this category.
    .EXAMPLE
        New-SDPCategory -Name 'Hardware' -Description 'Hardware-related requests'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPCategory')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$TechnicianId
    )

    $body = @{ name = $Name }

    if ($PSBoundParameters.ContainsKey('Description'))  { $body['description'] = $Description }
    if ($PSBoundParameters.ContainsKey('TechnicianId')) { $body['technician']  = @{ id = $TechnicianId } }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Category')) {
        $response = Invoke-SDPRestMethod -Endpoint 'categories' -Method POST -Body @{ category = $body }
        [SDPCategory]::new($response.category)
    }
}
