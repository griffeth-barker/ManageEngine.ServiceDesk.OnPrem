function New-SDPRequest {
    <#
    .SYNOPSIS
        Creates a new request in ServiceDesk Plus.
    .PARAMETER Subject
        The subject line of the request.
    .PARAMETER Description
        Detailed description of the request.
    .PARAMETER RequesterName
        Name of the requester.
    .PARAMETER TechnicianName
        Name of the technician to assign.
    .PARAMETER GroupName
        Name of the support group to assign.
    .PARAMETER StatusName
        Name of the status to set (e.g. 'Open').
    .PARAMETER PriorityName
        Name of the priority (e.g. 'High').
    .PARAMETER UrgencyName
        Name of the urgency level.
    .PARAMETER ImpactName
        Name of the impact level.
    .PARAMETER CategoryName
        Name of the category.
    .PARAMETER SubcategoryName
        Name of the subcategory.
    .PARAMETER ItemName
        Name of the item.
    .PARAMETER SiteName
        Name of the site.
    .PARAMETER ModeName
        Name of the mode (e.g. 'E-Mail', 'Phone Call').
    .PARAMETER LevelName
        Name of the level (e.g. 'Tier 1').
    .PARAMETER RequestTypeName
        Name of the request type (e.g. 'Incident', 'Service Request').
    .PARAMETER DueByTime
        Due date/time for the request.
    .PARAMETER ImpactDetails
        Free-text impact details.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body (e.g. UDF fields).
    .EXAMPLE
        New-SDPRequest -Subject 'Cannot access email'
    .EXAMPLE
        New-SDPRequest -Subject 'VPN issue' -RequesterName 'Jane Smith' -PriorityName 'High' -TechnicianName 'Bob Jones'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequest')]
    param(
        [Parameter(Mandatory)]
        [string]$Subject,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$RequesterName,

        [Parameter()]
        [string]$TechnicianName,

        [Parameter()]
        [string]$GroupName,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$UrgencyName,

        [Parameter()]
        [string]$ImpactName,

        [Parameter()]
        [string]$CategoryName,

        [Parameter()]
        [string]$SubcategoryName,

        [Parameter()]
        [string]$ItemName,

        [Parameter()]
        [string]$SiteName,

        [Parameter()]
        [string]$ModeName,

        [Parameter()]
        [string]$LevelName,

        [Parameter()]
        [string]$RequestTypeName,

        [Parameter()]
        [datetime]$DueByTime,

        [Parameter()]
        [string]$ImpactDetails,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    $body = @{ subject = $Subject }

    if ($PSBoundParameters.ContainsKey('Description'))     { $body['description']    = $Description }
    if ($PSBoundParameters.ContainsKey('ImpactDetails'))   { $body['impact_details'] = $ImpactDetails }
    if ($PSBoundParameters.ContainsKey('RequesterName'))   { $body['requester']      = @{ name = $RequesterName } }
    if ($PSBoundParameters.ContainsKey('TechnicianName'))  { $body['technician']     = @{ name = $TechnicianName } }
    if ($PSBoundParameters.ContainsKey('GroupName'))       { $body['group']          = @{ name = $GroupName } }
    if ($PSBoundParameters.ContainsKey('StatusName'))      { $body['status']         = @{ name = $StatusName } }
    if ($PSBoundParameters.ContainsKey('PriorityName'))    { $body['priority']       = @{ name = $PriorityName } }
    if ($PSBoundParameters.ContainsKey('UrgencyName'))     { $body['urgency']        = @{ name = $UrgencyName } }
    if ($PSBoundParameters.ContainsKey('ImpactName'))      { $body['impact']         = @{ name = $ImpactName } }
    if ($PSBoundParameters.ContainsKey('CategoryName'))    { $body['category']       = @{ name = $CategoryName } }
    if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory']    = @{ name = $SubcategoryName } }
    if ($PSBoundParameters.ContainsKey('ItemName'))        { $body['item']           = @{ name = $ItemName } }
    if ($PSBoundParameters.ContainsKey('SiteName'))        { $body['site']           = @{ name = $SiteName } }
    if ($PSBoundParameters.ContainsKey('ModeName'))        { $body['mode']           = @{ name = $ModeName } }
    if ($PSBoundParameters.ContainsKey('LevelName'))       { $body['level']          = @{ name = $LevelName } }
    if ($PSBoundParameters.ContainsKey('RequestTypeName')) { $body['request_type']   = @{ name = $RequestTypeName } }
    if ($PSBoundParameters.ContainsKey('DueByTime')) {
        $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
    }

    if ($AdditionalFields) {
        foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
    }

    if ($PSCmdlet.ShouldProcess($Subject, 'Create SDP Request')) {
        $response = Invoke-SDPRestMethod -Endpoint 'requests' -Method POST -Body @{ request = $body }
        [SDPRequest]::new($response.request)
    }
}
