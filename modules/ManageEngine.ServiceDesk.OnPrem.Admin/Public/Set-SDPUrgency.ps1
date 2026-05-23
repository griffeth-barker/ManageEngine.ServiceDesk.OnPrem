function Set-SDPUrgency {
    <#
    .SYNOPSIS
        Updates an existing urgency in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the urgency to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPUrgency -Id '1' -Name 'Updated Urgency Name'
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

        if ($PSCmdlet.ShouldProcess("Urgency $Id", 'Update SDP Urgency')) {
            $response = Invoke-SDPRestMethod -Endpoint "urgencies/$Id" -Method PUT -Body @{ urgency = $body }
            [SDPReference]::new($response.urgency)
        }
    }
}
