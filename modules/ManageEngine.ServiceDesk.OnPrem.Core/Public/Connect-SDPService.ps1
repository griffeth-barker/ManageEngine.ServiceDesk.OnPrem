function Connect-SDPService {
    <#
    .SYNOPSIS
        Establishes a connection to a ServiceDesk Plus on-premises instance.
    .DESCRIPTION
        Stores the base URI, technician API key, and portal ID in module scope for use by all other functions.
        Subsequent calls overwrite the existing session.
    .PARAMETER BaseUri
        The fully-qualified base URI of your SDP instance, e.g. 'https://sdp.corp.local:8080'.
        The module appends '/api/v3' automatically.
    .PARAMETER TechnicianKey
        The API key for the technician account, as a SecureString. Generate this in the SDP admin console
        under Admin > Technicians > API Key.
    .PARAMETER PortalId
        The portal ID of the SDP instance. Defaults to 1, which is the default for a single-portal installation.
    .PARAMETER SkipCertificateCheck
        Skips SSL certificate validation. Use this when connecting to an instance with a self-signed
        or otherwise untrusted certificate.
    .PARAMETER PassThru
        Returns the SDPConnection object after connecting.
    .EXAMPLE
        Connect-SDPService -BaseUri 'https://sdp.corp.local:8080' -TechnicianKey (Read-Host -AsSecureString)
    .EXAMPLE
        $key = ConvertTo-SecureString 'myapikey' -AsPlainText -Force
        Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -PortalId 2 -SkipCertificateCheck
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPConnection')]
    param(
        [Parameter(Mandatory)]
        [string]$BaseUri,

        [Parameter(Mandatory)]
        [securestring]$TechnicianKey,

        [Parameter()]
        [int]$PortalId = 1,

        [Parameter()]
        [switch]$SkipCertificateCheck,

        [Parameter()]
        [switch]$PassThru
    )

    if ($PSCmdlet.ShouldProcess($BaseUri, 'Connect to SDP service')) {
        $script:SDPSession = [SDPConnection]::new($BaseUri, $TechnicianKey, $PortalId, $SkipCertificateCheck.IsPresent)

        if ($PassThru) {
            $script:SDPSession
        }
    }
}
