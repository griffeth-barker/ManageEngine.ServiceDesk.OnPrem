function New-SDPRequestResolution {
    <#
    .SYNOPSIS
        Adds or replaces the resolution for a ServiceDesk Plus request.
    .DESCRIPTION
        The SDP on-premises API does not support updating an existing resolution; calling this
        function on a request that already has a resolution replaces it.
    .PARAMETER RequestId
        The ID of the request.
    .PARAMETER Content
        The resolution text.
    .EXAMPLE
        New-SDPRequestResolution -RequestId '12345' -Content 'Rebooted the server. Issue resolved.'
    .EXAMPLE
        Get-SDPRequest -Id '12345' | New-SDPRequestResolution -Content 'Replaced faulty NIC.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequestResolution')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId,

        [Parameter(Mandatory)]
        [string]$Content
    )

    process {
        if ($PSCmdlet.ShouldProcess("Request $RequestId", 'Set SDP Request Resolution')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/resolutions" -Method POST -Body @{
                resolution = @{ content = $Content }
            }
            [SDPRequestResolution]::new($RequestId, $response.resolution)
        }
    }
}
