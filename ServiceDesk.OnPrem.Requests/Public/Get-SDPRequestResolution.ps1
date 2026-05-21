function Get-SDPRequestResolution {
    <#
    .SYNOPSIS
        Retrieves the resolution for a ServiceDesk Plus request.
    .PARAMETER RequestId
        The ID of the request.
    .EXAMPLE
        Get-SDPRequestResolution -RequestId '12345'
    .EXAMPLE
        Get-SDPRequest -Id '12345' | Get-SDPRequestResolution
    #>
    [CmdletBinding()]
    [OutputType('SDPRequestResolution')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$RequestId
    )

    process {
        $response = Invoke-SDPRestMethod -Endpoint "requests/$RequestId/resolutions"
        if ($response.resolution) {
            [SDPRequestResolution]::new($RequestId, $response.resolution)
        }
    }
}
