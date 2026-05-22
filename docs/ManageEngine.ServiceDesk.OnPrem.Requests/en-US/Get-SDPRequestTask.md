---
external help file: ManageEngine.ServiceDesk.OnPrem.Requests-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Requests
online version:
schema: 2.0.0
---

# Get-SDPRequestTask

## SYNOPSIS
Retrieves tasks for a ServiceDesk Plus request.

## SYNTAX

### List (Default)
```
Get-SDPRequestTask -RequestId <String> [-PageSize <Int32>] [-StartIndex <Int32>] [-All]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-SDPRequestTask -RequestId <String> -Id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SDPRequestTask -RequestId '12345'
```

### EXAMPLE 2
```
Get-SDPRequestTask -RequestId '12345' -Id '1'
```

## PARAMETERS

### -RequestId
The ID of the parent request.

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

### -Id
The ID of a specific task to retrieve.

```yaml
Type: String
Parameter Sets: Id
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

### SDPRequestTask
## NOTES

## RELATED LINKS
