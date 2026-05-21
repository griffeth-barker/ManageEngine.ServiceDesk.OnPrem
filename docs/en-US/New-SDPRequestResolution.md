---
external help file: ServiceDesk.OnPrem.Requests-help.xml
Module Name: ServiceDesk.OnPrem.Requests
online version:
schema: 2.0.0
---

# New-SDPRequestResolution

## SYNOPSIS
Adds or replaces the resolution for a ServiceDesk Plus request.

## SYNTAX

```
New-SDPRequestResolution [-RequestId] <String> [-Content] <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The SDP on-premises API does not support updating an existing resolution; calling this
function on a request that already has a resolution replaces it.

## EXAMPLES

### EXAMPLE 1
```
New-SDPRequestResolution -RequestId '12345' -Content 'Rebooted the server. Issue resolved.'
```

### EXAMPLE 2
```
Get-SDPRequest -Id '12345' | New-SDPRequestResolution -Content 'Replaced faulty NIC.'
```

## PARAMETERS

### -RequestId
The ID of the request.

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

### -Content
The resolution text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### SDPRequestResolution
## NOTES

## RELATED LINKS
