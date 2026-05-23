---
external help file: ManageEngine.ServiceDesk.OnPrem.Changes-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Changes
online version:
schema: 2.0.0
---

# Get-SDPChangeStatus

## SYNOPSIS
Retrieves one or more change statuses from ServiceDesk Plus.

## SYNTAX

### List (Default)
```
Get-SDPChangeStatus [-PageSize <Int32>] [-StartIndex <Int32>] [-All] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-SDPChangeStatus -Id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPChangeStatus
```

### EXAMPLE 2
```
Get-SDPChangeStatus -Id '1'
```

## PARAMETERS

### -Id
The ID of the change status to retrieve.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PageSize
Number of records per page (1-100).
Defaults to 100.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartIndex
1-based starting index.
Defaults to 1.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Automatically pages through all results.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
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

## NOTES

## RELATED LINKS
