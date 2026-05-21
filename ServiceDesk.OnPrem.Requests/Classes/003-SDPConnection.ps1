class SDPConnection {
    [string]$ApiBaseUri
    [int]$PortalId
    [securestring]$TechnicianKey
    [bool]$SkipCertificateCheck

    SDPConnection([string]$baseUri, [securestring]$technicianKey, [int]$portalId, [bool]$skipCertificateCheck) {
        $this.ApiBaseUri          = $baseUri.TrimEnd('/') + '/api/v3'
        $this.TechnicianKey       = $technicianKey
        $this.PortalId            = $portalId
        $this.SkipCertificateCheck = $skipCertificateCheck
    }

    hidden [string] GetPlainKey() {
        return [System.Net.NetworkCredential]::new('', $this.TechnicianKey).Password
    }
}
