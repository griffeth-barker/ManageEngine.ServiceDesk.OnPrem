function Copy-SDPChange {
    <#
    .SYNOPSIS
        Creates a copy of an existing change in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change to copy.
    .EXAMPLE
        Copy-SDPChange -Id '12345'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChange')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Change $Id", 'Copy SDP Change')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$Id/copy" -Method POST
            [SDPChange]::new($response.change)
        }
    }
}
