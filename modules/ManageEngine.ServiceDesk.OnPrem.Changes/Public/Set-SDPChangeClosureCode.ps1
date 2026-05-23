function Set-SDPChangeClosureCode {
    <#
    .SYNOPSIS
        Updates a change closure code in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the closure code to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeClosureCode -Id '1' -Name 'Rolled Back'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
    if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

    if ($PSCmdlet.ShouldProcess("Closure code $Id", 'Update SDP Change closure code')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_closure_codes/$Id" -Method PUT -Body @{ change_closure_code = $body }
        [SDPReference]::new($response.change_closure_code)
    }
}
