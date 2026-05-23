function New-SDPUrgency {
    <#
    .SYNOPSIS
        Creates a new urgency in ServiceDesk Plus.
    .PARAMETER Name
        Name of the urgency.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPUrgency -Name 'Custom Urgency'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReference')]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{ name = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Urgency')) {
        $response = Invoke-SDPRestMethod -Endpoint 'urgencies' -Method POST -Body @{ urgency = $body }
        [SDPReference]::new($response.urgency)
    }
}
