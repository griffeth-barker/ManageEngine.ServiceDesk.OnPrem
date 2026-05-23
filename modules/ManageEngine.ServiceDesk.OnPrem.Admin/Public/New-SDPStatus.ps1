function New-SDPStatus {
    <#
    .SYNOPSIS
        Creates a new status in ServiceDesk Plus.
    .PARAMETER Name
        Name of the status.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPStatus -Name 'Custom Status'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Status')) {
        $response = Invoke-SDPRestMethod -Endpoint 'statuses' -Method POST -Body @{ status = $body }
        [SDPReference]::new($response.status)
    }
}
