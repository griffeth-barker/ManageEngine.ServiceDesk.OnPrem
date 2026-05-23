function New-SDPChangeStatus {
    <#
    .SYNOPSIS
        Creates a new change status in ServiceDesk Plus.
    .PARAMETER Name
        Name of the change status.
    .PARAMETER Description
        Optional description.
    .EXAMPLE
        New-SDPChangeStatus -Name 'Pending CAB Approval'
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

    if ($PSCmdlet.ShouldProcess($Name, 'Create SDP Change status')) {
        $response = Invoke-SDPRestMethod -Endpoint 'change_statuses' -Method POST -Body @{ change_status = $body }
        [SDPReference]::new($response.change_status)
    }
}
