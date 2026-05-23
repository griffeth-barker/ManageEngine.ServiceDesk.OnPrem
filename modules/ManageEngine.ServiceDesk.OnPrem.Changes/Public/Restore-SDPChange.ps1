function Restore-SDPChange {
    <#
    .SYNOPSIS
        Restores a trashed change in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the change to restore from trash.
    .EXAMPLE
        Restore-SDPChange -Id '12345'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChange')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess("Change $Id", 'Restore SDP Change from trash')) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$Id/restore_from_trash" -Method PUT
            [SDPChange]::new($response.change)
        }
    }
}
