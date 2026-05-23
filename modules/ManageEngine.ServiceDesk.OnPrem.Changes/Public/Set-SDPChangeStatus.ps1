function Set-SDPChangeStatus {
    <#
    .SYNOPSIS
        Updates a change status in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change status to update.
    .PARAMETER Name
        Updated name.
    .PARAMETER Description
        Updated description.
    .EXAMPLE
        Set-SDPChangeStatus -Id '1' -Name 'Approved'
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

    if ($PSCmdlet.ShouldProcess("Change status $Id", 'Update SDP Change status')) {
        $response = Invoke-SDPRestMethod -Endpoint "change_statuses/$Id" -Method PUT -Body @{ change_status = $body }
        [SDPReference]::new($response.change_status)
    }
}
