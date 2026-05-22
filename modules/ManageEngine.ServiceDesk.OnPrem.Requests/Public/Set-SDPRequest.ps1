function Set-SDPRequest {
    <#
    .SYNOPSIS
        Updates an existing request in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the request to update.
    .PARAMETER Subject
        New subject line.
    .PARAMETER Description
        New description.
    .PARAMETER RequesterName
        Name of the requester to set.
    .PARAMETER TechnicianName
        Name of the technician to assign.
    .PARAMETER GroupName
        Name of the support group to assign.
    .PARAMETER StatusName
        Name of the status to set (e.g. 'Closed', 'On Hold').
    .PARAMETER PriorityName
        Name of the priority.
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
    .PARAMETER DueByTime
        Updated due date/time.
    .PARAMETER ImpactDetails
        Updated impact details.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPRequest -Id '12345' -StatusName 'Closed'
    .EXAMPLE
        Get-SDPRequest -Id '12345' | Set-SDPRequest -PriorityName 'High' -TechnicianName 'Bob Jones'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPRequest')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [datetime]$DueByTime,

        [Parameter()]
        [string]$ImpactDetails,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Subject'))         { $body['subject']        = $Subject }
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
        if ($PSBoundParameters.ContainsKey('DueByTime')) {
            $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if ($PSCmdlet.ShouldProcess("Request $Id", 'Update SDP Request')) {
            $response = Invoke-SDPRestMethod -Endpoint "requests/$Id" -Method PUT -Body @{ request = $body }
            [SDPRequest]::new($response.request)
        }
    }
}
