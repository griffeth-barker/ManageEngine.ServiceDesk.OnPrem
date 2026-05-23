function Set-SDPMode {
    <#
    .SYNOPSIS
        Updates an existing mode in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the mode to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPMode -Id '1' -Name 'Updated Mode Name'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPReference')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Name'))        { $body['name']        = $Name }
        if ($PSBoundParameters.ContainsKey('Description')) { $body['description'] = $Description }

        if ($PSCmdlet.ShouldProcess("Mode $Id", 'Update SDP Mode')) {
            $response = Invoke-SDPRestMethod -Endpoint "modes/$Id" -Method PUT -Body @{ mode = $body }
            [SDPReference]::new($response.mode)
        }
    }
}
