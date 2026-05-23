function Set-SDPPriority {
    <#
    .SYNOPSIS
        Updates an existing priority in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the priority to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPPriority -Id '1' -Name 'Updated Priority Name'
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

        if ($PSCmdlet.ShouldProcess("Priority $Id", 'Update SDP Priority')) {
            $response = Invoke-SDPRestMethod -Endpoint "priorities/$Id" -Method PUT -Body @{ priority = $body }
            [SDPReference]::new($response.priority)
        }
    }
}
