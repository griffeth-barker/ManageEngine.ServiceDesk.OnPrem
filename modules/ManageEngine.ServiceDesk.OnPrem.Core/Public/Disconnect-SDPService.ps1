function Disconnect-SDPService {
    <#
    .SYNOPSIS
        Removes the active ServiceDesk Plus session from module scope.
    .DESCRIPTION
        Clears the stored connection. Subsequent calls to any SDP function will fail until
        Connect-SDPService is called again.
    .EXAMPLE
        Disconnect-SDPService
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($PSCmdlet.ShouldProcess('SDP session', 'Disconnect')) {
        $script:SDPSession = $null
    }
}
