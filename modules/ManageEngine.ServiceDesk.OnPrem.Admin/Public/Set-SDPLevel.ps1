function Set-SDPLevel {
    <#
    .SYNOPSIS
        Updates an existing level in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the level to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPLevel -Id '1' -Name 'Updated Level Name'
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

        if ($PSCmdlet.ShouldProcess("Level $Id", 'Update SDP Level')) {
            $response = Invoke-SDPRestMethod -Endpoint "levels/$Id" -Method PUT -Body @{ level = $body }
            [SDPReference]::new($response.level)
        }
    }
}
