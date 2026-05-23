function Set-SDPChange {
    <#
    .SYNOPSIS
        Updates an existing change in ServiceDesk Plus.
    .DESCRIPTION
        Updates core change fields via PUT /changes/:id. Descriptive fields (BackOutPlan,
        RolloutPlan, ImpactAnalysis, Checklist) are updated via separate sub-resource calls to
        the descriptive_fields endpoint; the cmdlet fetches each field's ID before updating.
    .PARAMETER Id
        The ID of the change to update.
    .PARAMETER Title
        New title.
    .PARAMETER Description
        New description.
    .PARAMETER ChangeTypeName
        Name of the change type.
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
    .PARAMETER ClosureCodeName
        Name of the closure code.
    .PARAMETER ScheduledStartTime
        Updated planned start date/time.
    .PARAMETER ScheduledEndTime
        Updated planned end date/time.
    .PARAMETER BackOutPlan
        Updated back-out plan content.
    .PARAMETER RolloutPlan
        Updated rollout plan content.
    .PARAMETER ImpactAnalysis
        Updated impact analysis content.
    .PARAMETER Checklist
        Updated checklist content.
    .PARAMETER AdditionalFields
        Hashtable of additional fields to merge into the request body.
    .EXAMPLE
        Set-SDPChange -Id '12345' -StatusName 'Implementation'
    .EXAMPLE
        Get-SDPChange -Id '12345' | Set-SDPChange -BackOutPlan 'Step 1: Restore from snapshot.'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('SDPChange')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
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
        [string]$ClosureCodeName,

        [Parameter()]
        [datetime]$ScheduledStartTime,

        [Parameter()]
        [datetime]$ScheduledEndTime,

        [Parameter()]
        [string]$BackOutPlan,

        [Parameter()]
        [string]$RolloutPlan,

        [Parameter()]
        [string]$ImpactAnalysis,

        [Parameter()]
        [string]$Checklist,

        [Parameter()]
        [hashtable]$AdditionalFields
    )

    process {
        $body = @{}

        if ($PSBoundParameters.ContainsKey('Title'))         { $body['title']        = $Title }
        if ($PSBoundParameters.ContainsKey('Description'))   { $body['description']  = $Description }
        if ($PSBoundParameters.ContainsKey('ChangeTypeName')) { $body['change_type'] = @{ name = $ChangeTypeName } }
        if ($PSBoundParameters.ContainsKey('StatusName'))    { $body['status']       = @{ name = $StatusName } }
        if ($PSBoundParameters.ContainsKey('PriorityName'))  { $body['priority']     = @{ name = $PriorityName } }
        if ($PSBoundParameters.ContainsKey('UrgencyName'))   { $body['urgency']      = @{ name = $UrgencyName } }
        if ($PSBoundParameters.ContainsKey('ImpactName'))    { $body['impact']       = @{ name = $ImpactName } }
        if ($PSBoundParameters.ContainsKey('RiskName'))      { $body['risk']         = @{ name = $RiskName } }
        if ($PSBoundParameters.ContainsKey('ReasonName'))    { $body['reason']       = @{ name = $ReasonName } }
        if ($PSBoundParameters.ContainsKey('RequesterName')) { $body['requester']    = @{ name = $RequesterName } }
        if ($PSBoundParameters.ContainsKey('TechnicianName')) { $body['technician']  = @{ name = $TechnicianName } }
        if ($PSBoundParameters.ContainsKey('GroupName'))     { $body['group']        = @{ name = $GroupName } }
        if ($PSBoundParameters.ContainsKey('SiteName'))      { $body['site']         = @{ name = $SiteName } }
        if ($PSBoundParameters.ContainsKey('DepartmentName')) { $body['department']  = @{ name = $DepartmentName } }
        if ($PSBoundParameters.ContainsKey('CategoryName'))  { $body['category']     = @{ name = $CategoryName } }
        if ($PSBoundParameters.ContainsKey('SubcategoryName')) { $body['subcategory'] = @{ name = $SubcategoryName } }
        if ($PSBoundParameters.ContainsKey('ClosureCodeName')) { $body['closure_code'] = @{ name = $ClosureCodeName } }

        if ($PSBoundParameters.ContainsKey('ScheduledStartTime')) {
            $body['scheduled_start_time'] = @{ value = [DateTimeOffset]::new($ScheduledStartTime).ToUnixTimeMilliseconds() }
        }
        if ($PSBoundParameters.ContainsKey('ScheduledEndTime')) {
            $body['scheduled_end_time'] = @{ value = [DateTimeOffset]::new($ScheduledEndTime).ToUnixTimeMilliseconds() }
        }

        if ($AdditionalFields) {
            foreach ($key in $AdditionalFields.Keys) { $body[$key] = $AdditionalFields[$key] }
        }

        if (-not $PSCmdlet.ShouldProcess("Change $Id", 'Update SDP Change')) { return }

        $response = $null
        if ($body.Count -gt 0) {
            $response = Invoke-SDPRestMethod -Endpoint "changes/$Id" -Method PUT -Body @{ change = $body }
        }

        # Descriptive fields require separate sub-resource calls
        $descriptiveFields = @{
            BackOutPlan    = 'back_out_plan'
            RolloutPlan    = 'rollout_plan'
            ImpactAnalysis = 'impact_analysis'
            Checklist      = 'checklist'
        }

        foreach ($param in $descriptiveFields.Keys) {
            if (-not $PSBoundParameters.ContainsKey($param)) { continue }
            $fieldKey     = $descriptiveFields[$param]
            $fieldContent = $PSBoundParameters[$param]
            $existing     = Invoke-SDPRestMethod -Endpoint "changes/$Id/descriptive_fields/$fieldKey"
            $fieldId      = $existing.$fieldKey.id
            Invoke-SDPRestMethod `
                -Endpoint "changes/$Id/descriptive_fields/$fieldKey/$fieldId" `
                -Method PUT `
                -Body @{ $fieldKey = @{ content = $fieldContent } } | Out-Null
        }

        if ($response) {
            [SDPChange]::new($response.change)
        } else {
            Get-SDPChange -Id $Id
        }
    }
}
