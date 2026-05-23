function New-SDPChangeClosureCode {
    <#
    .SYNOPSIS
        Creates a new change closure code in ServiceDesk Plus.
    .PARAMETER Name
        Name of the closure code.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeClosureCode -Name 'Successful'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{ name = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change closure code')) {
        $response = Invoke-SDPRestMethod -Endpoint 'change_closure_codes' -Method POST -Body @{ change_closure_code = $body }
        [SDPReference]::new($response.change_closure_code)
    }
}
