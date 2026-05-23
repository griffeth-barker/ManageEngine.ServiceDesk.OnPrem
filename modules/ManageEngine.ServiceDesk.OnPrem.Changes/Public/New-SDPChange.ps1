function New-SDPChange {
    <#
    .SYNOPSIS
        Creates a new change in ServiceDesk Plus.
    .PARAMETER Title
        The title of the change.
    .PARAMETER Description
        Detailed description of the change.
    .PARAMETER ChangeTypeName
        Name of the change type (e.g. 'Normal', 'Emergency', 'Standard').
    .PARAMETER StatusName
        Name of the status to set.
    .PARAMETER PriorityName
        Name of the priority.
    .PARAMETER UrgencyName
        Name of the urgency level.
    .PARAMETER ImpactName
        Name of the impact level.
    .PARAMETER RiskName
        Name of the risk level.
    .PARAMETER ReasonName
        Name of the reason for change.
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
    .PARAMETER ScheduledStartTime
        Planned start date/time.
    .PARAMETER ScheduledEndTime
        Planned end date/time.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to include in the request body (e.g. UDF fields).
    .EXAMPLE
        New-SDPChange -Title 'Upgrade database server'
    .EXAMPLE
        New-SDPChange -Title 'Patch management rollout' -ChangeTypeName 'Normal' -PriorityName 'High' -TechnicianName 'Bob Jones'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChange')]
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [string]$ChangeTypeName,

        [Parameter()]
        [string]$StatusName,

        [Parameter()]
        [string]$PriorityName,

        [Parameter()]
        [string]$UrgencyName,

        [Parameter()]
        [string]$ImpactName,

        [Parameter()]
        [string]$RiskName,

        [Parameter()]
        [string]$ReasonName,

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
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    $body = @{ title = $Title }

    if ($PSBoundParameters.ContainsKey('Description'))    { $body['description']  = $Description }
    if ($PSBoundParameters.ContainsKey('ChangeTypeName')) { $body['change_type']  = @{ name = $ChangeTypeName } }
    if ($PSBoundParameters.ContainsKey('StatusName'))     { $body['status']       = @{ name = $StatusName } }
    if ($PSBoundParameters.ContainsKey('PriorityName'))   { $body['priority']     = @{ name = $PriorityName } }
    if ($PSBoundParameters.ContainsKey('UrgencyName'))    { $body['urgency']      = @{ name = $UrgencyName } }
    if ($PSBoundParameters.ContainsKey('ImpactName'))     { $body['impact']       = @{ name = $ImpactName } }
    if ($PSBoundParameters.ContainsKey('RiskName'))       { $body['risk']         = @{ name = $RiskName } }
    if ($PSBoundParameters.ContainsKey('ReasonName'))     { $body['reason']       = @{ name = $ReasonName } }
    if ($PSBoundParameters.ContainsKey('RequesterName'))  { $body['requester']    = @{ name = $RequesterName } }
    if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician']   = @{ name = $TechnicianName } }
    if ($PSBoundParameters.ContainsKey('GroupName'))      { $body['group']        = @{ name = $GroupName } }
    if ($PSBoundParameters.ContainsKey('SiteName'))       { $body['site']         = @{ name = $SiteName } }
    if ($PSBoundParameters.ContainsKey('DepartmentName')) { $body['department']   = @{ name = $DepartmentName } }
    if ($PSBoundParameters.ContainsKey('CategoryName'))   { $body['category']     = @{ name = $CategoryName } }
    if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory'] = @{ name = $SubcategoryName } }

    if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
        $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
    }
    if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
        $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
    }

    if ($AdditionalFields) {
        foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
    }

    if ($PSCmdlet.ShouldProcess($Title, 'Create SDP Change')) {
        $response = Invoke-SDPRestMethod -Endpoint 'changes' -Method POST -Body @{ change = $body }
        [SDPChange]::new($response.change)
    }
}
