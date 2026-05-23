---
external help file: ManageEngine.ServiceDesk.OnPrem.Changes-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Changes
online version:
schema: 2.0.0
---

# Set-SDPChange

## SYNOPSIS
Updates an existing change in ServiceDesk Plus.

## SYNTAX

```
Set-SDPChange [-Id] <String> [[-Title] <String>] [[-Description] <String>] [[-ChangeTypeName] <String>]
 [[-StatusName] <String>] [[-PriorityName] <String>] [[-UrgencyName] <String>] [[-ImpactName] <String>]
 [[-RiskName] <String>] [[-ReasonName] <String>] [[-RequesterName] <String>] [[-TechnicianName] <String>]
 [[-GroupName] <String>] [[-SiteName] <String>] [[-DepartmentName] <String>] [[-CategoryName] <String>]
 [[-SubcategoryName] <String>] [[-ClosureCodeName] <String>] [[-ScheduledStartTime] <DateTime>]
 [[-ScheduledEndTime] <DateTime>] [[-BackOutPlan] <String>] [[-RolloutPlan] <String>]
 [[-ImpactAnalysis] <String>] [[-Checklist] <String>] [[-AdditionalFields] <Hashtable>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates core change fields via PUT /changes/:id.
Descriptive fields (BackOutPlan,
RolloutPlan, ImpactAnalysis, Checklist) are updated via separate sub-resource calls to
the descriptive_fields endpoint; the cmdlet fetches each field's ID before updating.

## EXAMPLES

### EXAMPLE 1
```
Set-SDPChange -Id '12345' -StatusName 'Implementation'
```

### EXAMPLE 2
```
Get-SDPChange -Id '12345' | Set-SDPChange -BackOutPlan 'Step 1: Restore from snapshot.'
```

## PARAMETERS

### -Id
The ID of the change to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
New title.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
New description.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChangeTypeName
Name of the change type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusName
Name of the status to set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PriorityName
Name of the priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UrgencyName
Name of the urgency level.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpactName
Name of the impact level.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RiskName
Name of the risk level.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReasonName
Name of the reason for change.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequesterName
Name of the requester.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TechnicianName
Name of the technician to assign.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupName
Name of the group to assign.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteName
Name of the site.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DepartmentName
Name of the department.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CategoryName
Name of the category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubcategoryName
Name of the subcategory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClosureCodeName
Name of the closure code.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledStartTime
Updated planned start date/time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledEndTime
Updated planned end date/time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackOutPlan
Updated back-out plan content.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RolloutPlan
Updated rollout plan content.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImpactAnalysis
Updated impact analysis content.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Checklist
Updated checklist content.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalFields
Hashtable of additional fields to merge into the request body.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SDPChange
## NOTES

## RELATED LINKS
