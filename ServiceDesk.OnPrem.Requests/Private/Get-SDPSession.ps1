function Get-SDPSession {
    [CmdletBinding()]
    [OutputType([SDPConnection])]
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
