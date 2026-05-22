function Invoke-SDPRestMethod {
    <#
    .SYNOPSIS
        Sends an authenticated HTTP request to the ServiceDesk Plus REST API.
    .DESCRIPTION
        Wraps Invoke-RestMethod with SDP-specific authentication headers, input_data encoding,
        and error translation. Sub-modules use this as their HTTP transport; callers can also use
        it directly for endpoints not yet covered by a dedicated cmdlet.
    .PARAMETER Endpoint
        The API endpoint path relative to the v3 base URI, e.g. 'requests' or 'requests/123/notes'.
    .PARAMETER Method
        HTTP method. Defaults to GET.
    .PARAMETER Body
        Request body hashtable, serialized as JSON and sent as form-encoded input_data.
        Used for POST/PUT/PATCH requests.
    .PARAMETER InputData
        Query-string hashtable, serialized as JSON and appended as the input_data parameter.
        Used for GET requests that require list_info or search criteria.
    .EXAMPLE
        Invoke-SDPRestMethod -Endpoint 'requests' -InputData @{ list_info = @{ row_count = 10 } }
    .EXAMPLE
        Invoke-SDPRestMethod -Endpoint 'requests/123' -Method PUT -Body @{ request = @{ status = @{ name = 'Closed' } } }
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',

        [Parameter()]
        [hashtable]$Body,

        [Parameter()]
        [hashtable]$InputData
    )

    $session = Get-SDPSession

    $uri = "$($session.ApiBaseUri)/$Endpoint"

    if ($InputData) {
        $encoded = [System.Uri]::EscapeDataString(($InputData | ConvertTo-Json -Depth 10 -Compress))
        $uri     = "${uri}?input_data=$encoded"
    }

    $headers = @{
        'TECHNICIAN_KEY' = $session.GetPlainKey()
        'PORTALID'       = $session.PortalId
        'Accept'         = 'application/vnd.manageengine.sdp.v3+json'
    }

    $params = @{
        Uri                  = $uri
        Method               = $Method
        Headers              = $headers
        SkipHttpErrorCheck   = $true
        StatusCodeVariable   = 'httpStatus'
        SkipCertificateCheck = $session.SkipCertificateCheck
    }

    if ($Body -and $Method -in 'POST', 'PUT', 'PATCH') {
        $params['ContentType'] = 'application/x-www-form-urlencoded'
        $params['Body']        = @{ input_data = ($Body | ConvertTo-Json -Depth 10 -Compress) }
    }

    try {
        $response = Invoke-RestMethod @params
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }

    if ($null -ne $response -and $response.PSObject.Properties['response_status']) {
        $status = $response.response_status
        # response_status may be an array (approvals endpoint) or a single object
        $statusObj = if ($status -is [array]) { $status[0] } else { $status }

        if ($null -ne $statusObj -and $statusObj.status_code -ne 2000) {
            $messages = @($statusObj.messages).Where({ $_ }) | ForEach-Object {
                $parts = @()
                if ($_.message)     { $parts += $_.message }
                if ($_.field)       { $parts += "field=$($_.field)" }
                if ($_.status_code) { $parts += "code=$($_.status_code)" }
                $parts -join ', '
            }
            $msg = if ($messages) { $messages -join '; ' } else { "SDP API error (code $($statusObj.status_code))" }
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    [System.Exception]::new($msg),
                    'SDPApiError',
                    [System.Management.Automation.ErrorCategory]::InvalidResult,
                    $response
                )
            )
        }
    } elseif ($httpStatus -ge 400) {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                [System.Exception]::new("HTTP $httpStatus received from SDP API."),
                'SDPHttpError',
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $null
            )
        )
    }

    $response
}
