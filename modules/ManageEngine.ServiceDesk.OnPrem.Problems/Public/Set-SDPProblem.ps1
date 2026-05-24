function Set-SDPProblem {
    <#
    .SYNOPSIS
        Updates an existing problem in ServiceDesk Plus.
    .PARAMETER Id
        The ID of the problem to update.
    .PARAMETER Title
        New title.
    .PARAMETER Description
        New description.
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
    .PARAMETER ClosureCodeName
        Name of the closure code.
    .PARAMETER DueByTime
        Updated due date/time.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPProblem -Id '12345' -StatusName 'Open'
    .EXAMPLE
        Get-SDPProblem -Id '12345' | Set-SDPProblem -TechnicianName 'Bob Jones' -PriorityName 'High'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPProblem')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [string]$ClosureCodeName,

        [Parameter()]
        [datetime]$DueByTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))         { $body['title']        = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))   { $body['description']  = $Description }
        if ($PSBoundParameters.ContainsKey('StatusName'))    { $body['status']       = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))  { $body['priority']     = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('UrgencyName'))   { $body['urgency']      = @{ name = $UrgencyName } }
        if ($PSBoundParameters.ContainsKey('ImpactName'))    { $body['impact']       = @{ name = $ImpactName } }
        if ($PSBoundParameters.ContainsKey('RequesterName')) { $body['requester']    = @{ name = $RequesterName } }
        if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician']  = @{ name = $TechnicianName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))     { $body['group']        = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('SiteName'))      { $body['site']         = @{ name = $SiteName } }
        if ($PSBoundParameters.ContainsKey('DepartmentName')) { $body['department']  = @{ name = $DepartmentName } }
        if ($PSBoundParameters.ContainsKey('CategoryName'))  { $body['category']     = @{ name = $CategoryName } }
        if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory'] = @{ name = $SubcategoryName } }
        if ($PSBoundParameters.ContainsKey('ClosureCodeName')) { $body['closure_code'] = @{ name = $ClosureCodeName } }

        if ($PSBoundParameters.ContainsKey('DueByTime')) {
            $body['due_by_time'] = @{ value = [DateTimeOffset]::new($DueByTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if (-not $PSCmdlet.ShouldProcess("Problem $Id", 'Update SDP Problem')) { return }

        if ($body.Count -gt 0) {
            $response = Invoke-SDPRestMethod -Endpoint "problems/$Id" -Method PUT -Body @{ problem = $body }
            [SDPProblem]::new($response.problem)
        } else {
            Get-SDPProblem -Id $Id
        }
    }
}
