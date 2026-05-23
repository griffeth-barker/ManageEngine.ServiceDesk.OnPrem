function Set-SDPStatus {
    <#
    .SYNOPSIS
        Updates an existing status in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the status to update.
    .PARAMETER Name
        New name.
    .PARAMETER Description
        New description.
    .EXAMPLE
        Set-SDPStatus -Id '1' -Name 'Updated Status Name'
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

        if ($PSCmdlet.ShouldProcess("Status $Id", 'Update SDP Status')) {
            $response = Invoke-SDPRestMethod -Endpoint "statuses/$Id" -Method PUT -Body @{ status = $body }
            [SDPReference]::new($response.status)
        }
    }
}
