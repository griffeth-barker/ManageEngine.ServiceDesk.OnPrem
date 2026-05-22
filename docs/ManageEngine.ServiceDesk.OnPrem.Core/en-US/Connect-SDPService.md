---
external help file: ManageEngine.ServiceDesk.OnPrem.Core-help.xml
Module Name: ManageEngine.ServiceDesk.OnPrem.Core
online version:
schema: 2.0.0
---

# Connect-SDPService

## SYNOPSIS
Establishes a connection to a ServiceDesk Plus on-premises instance.

## SYNTAX

```
Connect-SDPService [-BaseUri] <String> [-TechnicianKey] <SecureString> [[-PortalId] <Int32>]
 [-SkipCertificateCheck] [-PassThru] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Stores the base URI, technician API key, and portal ID in module scope for use by all other functions.
Subsequent calls overwrite the existing session.

## EXAMPLES

### EXAMPLE 1
```
Connect-SDPService -BaseUri 'https://sdp.corp.local:8080' -TechnicianKey (Read-Host -AsSecureString)
```

### EXAMPLE 2
```
$key = ConvertTo-SecureString 'myapikey' -AsPlainText -Force
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -PortalId 2 -SkipCertificateCheck
```

## PARAMETERS

### -BaseUri
The fully-qualified base URI of your SDP instance, e.g.
'https://sdp.corp.local:8080'.
The module appends '/api/v3' automatically.

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

### -TechnicianKey
The API key for the technician account, as a SecureString.
Generate this in the SDP admin console
under Admin \> Technicians \> API Key.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
The portal ID of the SDP instance.
Defaults to 1, which is the default for a single-portal installation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Skips SSL certificate validation.
Use this when connecting to an instance with a self-signed
or otherwise untrusted certificate.

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

### -PassThru
Returns the SDPConnection object after connecting.

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

### SDPConnection
## NOTES

## RELATED LINKS
