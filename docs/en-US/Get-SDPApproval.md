---
external help file: ServiceDesk.OnPrem.Requests-help.xml
Module Name: ServiceDesk.OnPrem.Requests
online version:
schema: 2.0.0
---

# Get-SDPApproval

## SYNOPSIS
Retrieves pending approvals from ServiceDesk Plus.

## SYNTAX

```
Get-SDPApproval [[-PageSize] <Int32>] [[-StartIndex] <Int32>] [-All] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns approvals that are awaiting action.
This is a global list across all requests,
not scoped to a single request.

## EXAMPLES

### EXAMPLE 1
```
Get-SDPApproval
```

### EXAMPLE 2
```
Get-SDPApproval -All
```

## PARAMETERS

### -PageSize
Number of records per page (1-100).
Defaults to 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
