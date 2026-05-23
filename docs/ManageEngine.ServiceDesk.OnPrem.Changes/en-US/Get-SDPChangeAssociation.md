---
external help file: ManageEngine.ServiceDesk.OnPrem.Changes-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Changes
online version:
schema: 2.0.0
---

# Get-SDPChangeAssociation

## SYNOPSIS
Retrieves associations (requests, problems, projects) for a ServiceDesk Plus change.

## SYNTAX

```
Get-SDPChangeAssociation -ChangeId <String> -Type <String> [-PageSize <Int32>] [-StartIndex <Int32>] [-All]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPChangeAssociation -ChangeId '12345' -Type Problem
```

### EXAMPLE 2
```
Get-SDPChangeAssociation -ChangeId '12345' -Type InitiatedRequest -All
```

## PARAMETERS

### -ChangeId
The ID of the change.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Type
The type of association to retrieve:
  InitiatedRequest    - requests initiated by this change
  InitiatedByRequest  - requests that caused/initiated this change
  Problem             - problems associated with this change
  Project             - projects associated with this change

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of records per page (1-100).
Defaults to 100.

```yaml
Type: Int32
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
