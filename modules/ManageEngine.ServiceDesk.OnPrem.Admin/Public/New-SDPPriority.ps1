function New-SDPPriority {
    <#
    .SYNOPSIS
        Creates a new priority in ServiceDesk Plus.
    .PARAMETER Name
        Name of the priority.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPPriority -Name 'Custom Priority'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Priority')) {
        $response = Invoke-SDPRestMethod -Endpoint 'priorities' -Method POST -Body @{ priority = $body }
        [SDPReference]::new($response.priority)
    }
}
