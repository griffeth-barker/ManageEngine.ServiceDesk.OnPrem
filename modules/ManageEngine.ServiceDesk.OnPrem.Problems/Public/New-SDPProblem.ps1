function New-SDPProblem {
    <#
    .SYNOPSIS
        Creates a new problem in ServiceDesk Plus.
    .PARAMETER Title
        The title of the problem.
    .PARAMETER Description
        Detailed description of the problem.
    .PARAMETER StatusName
        Name of the status to set.
    .PARAMETER PriorityName
        Name of the priority.
    .PARAMETER UrgencyName
        Name of the urgency level.
    .PARAMETER ImpactName
        Name of the impact level.
    .PARAMETER RequesterName
        Name of the requester.
    .PARAMETER TechnicianName
        Name of the technician to assign.
    .PARAMETER GroupName
        Name of the group to assign.
    .PARAMETER SiteName
        Name of the site.
    .PARAMETER DepartmentName
        Name of the department.
    .PARAMETER CategoryName
        Name of the category.
    .PARAMETER SubcategoryName
        Name of the subcategory.
    .PARAMETER DueByTime
        Due date/time for the problem.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body (e.g. UDF fields).
    .EXAMPLE
        New-SDPProblem -Title 'Exchange server repeatedly crashing'
    .EXAMPLE
        New-SDPProblem -Title 'VPN disconnections affecting remote users' -PriorityName 'High' -TechnicianName 'Bob Jones'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblem')]
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$UrgencyName,

        [Parameter()]
        [string]$ImpactName,

        [Parameter()]
        [string]$RequesterName,

        [Parameter()]
        [string]$TechnicianName,

        [Parameter()]
        [string]$GroupName,

        [Parameter()]
        [string]$SiteName,

        [Parameter()]
        [string]$DepartmentName,

        [Parameter()]
        [string]$CategoryName,

        [Parameter()]
        [string]$SubcategoryName,

        [Parameter()]
        [datetime]$DueByTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    $body = @{ title = $Title }

    if ($PSBoundParameters.ContainsKey('Description'))    { $body['description']  = $Description }
    if ($PSBoundParameters.ContainsKey('StatusName'))     { $body['status']       = @{ name = $StatusName } }
    if ($PSBoundParameters.ContainsKey('PriorityName'))   { $body['priority']     = @{ name = $PriorityName } }
    if ($PSBoundParameters.ContainsKey('UrgencyName'))    { $body['urgency']      = @{ name = $UrgencyName } }
    if ($PSBoundParameters.ContainsKey('ImpactName'))     { $body['impact']       = @{ name = $ImpactName } }
    if ($PSBoundParameters.ContainsKey('RequesterName'))  { $body['requester']    = @{ name = $RequesterName } }
    if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician']   = @{ name = $TechnicianName } }
    if ($PSBoundParameters.ContainsKey('GroupName'))      { $body['group']        = @{ name = $GroupName } }
    if ($PSBoundParameters.ContainsKey('SiteName'))       { $body['site']         = @{ name = $SiteName } }
    if ($PSBoundParameters.ContainsKey('DepartmentName')) { $body['department']   = @{ name = $DepartmentName } }
    if ($PSBoundParameters.ContainsKey('CategoryName'))   { $body['category']     = @{ name = $CategoryName } }
    if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory'] = @{ name = $SubcategoryName } }

    if ($PSBoundParameters.ContainsKey('DueByTime')) {
        $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
    }

    if ($AdditionalFields) {
        foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
    }

    if ($PSCmdlet.ShouldProcess($Title, 'Create SDP Problem')) {
        $response = Invoke-SDPRestMethod -Endpoint 'problems' -Method POST -Body @{ problem = $body }
        [SDPProblem]::new($response.problem)
    }
}
