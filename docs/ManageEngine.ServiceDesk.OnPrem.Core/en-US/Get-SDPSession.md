---
external help file: ManageEngine.ServiceDesk.OnPrem.Core-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Core
online version:
schema: 2.0.0
---

# Get-SDPSession

## SYNOPSIS
Returns the active ServiceDesk Plus connection object.

## SYNTAX

```
Get-SDPSession [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns the SDPConnection object stored by Connect-SDPService.
Throws if no session is active.
Sub-modules use this function to retrieve connection details without needing direct access to
module-scoped variables.

## EXAMPLES

### EXAMPLE 1
```
Get-SDPSession
```

## PARAMETERS

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

### SDPConnection
## NOTES

## RELATED LINKS
