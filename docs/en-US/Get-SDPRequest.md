---
external help file: ServiceDesk.OnPrem.Requests-help.xml
Module Name: ServiceDesk.OnPrem.Requests
online version:
schema: 2.0.0
---

# Get-SDPRequest

## SYNOPSIS
Retrieves one or more requests from ServiceDesk Plus.

## SYNTAX

### List (Default)
```
Get-SDPRequest [-PageSize <Int32>] [-StartIndex <Int32>] [-SortField <String>] [-SortOrder <String>]
 [-Filter <Hashtable[]>] [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-SDPRequest -Id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Use the Id parameter set to fetch a single request by ID.
Use the List parameter set (default) to retrieve a paged list, optionally filtered and sorted.

## EXAMPLES

### EXAMPLE 1
```
Get-SDPRequest -Id '12345'
```

### EXAMPLE 2
```
Get-SDPRequest -All
```

### EXAMPLE 3
```
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' })
```

## PARAMETERS

### -Id
The ID of the request to retrieve.

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
1-based starting index for the page.
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

### -SortField
Field name to sort by (e.g.
'created_time', 'subject').

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder
Sort direction: 'asc' or 'desc'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
An array of search criteria hashtables.
Each hashtable should contain 'field', 'value',
'condition' (e.g.
'contains', 'eq'), and optionally 'logical_operator' ('and'/'or').

```yaml
Type: Hashtable[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Automatically pages through all results and returns every request matching the criteria.

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

### SDPRequest
## NOTES

## RELATED LINKS
