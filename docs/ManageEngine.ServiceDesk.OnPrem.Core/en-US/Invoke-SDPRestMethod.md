---
external help file: ManageEngine.ServiceDesk.OnPrem.Core-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Core
online version:
schema: 2.0.0
---

# Invoke-SDPRestMethod

## SYNOPSIS
Sends an authenticated HTTP request to the ServiceDesk Plus REST API.

## SYNTAX

```
Invoke-SDPRestMethod [-Endpoint] <String> [[-Method] <WebRequestMethod>] [[-Body] <Hashtable>]
 [[-InputData] <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps Invoke-RestMethod with SDP-specific authentication headers, input_data encoding,
and error translation.
Sub-modules use this as their HTTP transport; callers can also use
it directly for endpoints not yet covered by a dedicated cmdlet.

## EXAMPLES

### EXAMPLE 1
```
Invoke-SDPRestMethod -Endpoint 'requests' -InputData @{ list_info = @{ row_count = 10 } }
```

### EXAMPLE 2
```
Invoke-SDPRestMethod -Endpoint 'requests/123' -Method PUT -Body @{ request = @{ status = @{ name = 'Closed' } } }
```

## PARAMETERS

### -Endpoint
The API endpoint path relative to the v3 base URI, e.g.
'requests' or 'requests/123/notes'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
HTTP method.
Defaults to GET.

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 2
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Request body hashtable, serialized as JSON and sent as form-encoded input_data.
Used for POST/PUT/PATCH requests.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputData
Query-string hashtable, serialized as JSON and appended as the input_data parameter.
Used for GET requests that require list_info or search criteria.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

## NOTES

## RELATED LINKS
