function Get-SDPSession {
    <#
    .SYNOPSIS
        Returns the active ServiceDesk Plus connection object.
    .DESCRIPTION
        Returns the SDPConnection object stored by Connect-SDPService. Throws if no session is active.
        Sub-modules use this function to retrieve connection details without needing direct access to
        module-scoped variables.
    .EXAMPLE
        Get-SDPSession
    #>
    [CmdletBinding()]
    [OutputType('SDPConnection')]
    param()

    if ($null -eq $script:SDPSession) {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new('No active SDP session. Run Connect-SDPService first.'),
                'SDPNotConnected',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $null
            )
        )
    }

    $script:SDPSession
}
