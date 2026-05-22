![](assets/manageengine-servicedesk-psmodules-logo-x256-nobg.png)

# ManageEngine.ServiceDesk.OnPrem

A PowerShell module family for the [ManageEngine ServiceDesk Plus On-Prem](https://www.manageengine.com/products/service-desk/on-premises/) REST API.

> **DISCLAIMER:**  
> This module is **not** affiliated with nor supported by Zoho/ManageEngine.
> This code should be considered experimental. You should understand the code that you choose to run on your systems. This code should not be considered production ready as long as this banner is present and/or the module version is < 1.0.0.

## Modules

| Module | Description |
|---|---|
| `ManageEngine.ServiceDesk.OnPrem` | Umbrella — installs all sub-modules |
| `ManageEngine.ServiceDesk.OnPrem.Core` | Authentication, session management, HTTP transport |
| `ManageEngine.ServiceDesk.OnPrem.Requests` | Requests, notes, tasks, worklogs, resolutions, approvals |
| `ManageEngine.ServiceDesk.OnPrem.Changes` | *Currently in development* |
| `ManageEngine.ServiceDesk.OnPrem.Assets` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Cmdb` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Releases` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Problems` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Projects` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Admin` | *Future* |

Install the umbrella module to get everything:

```powershell
Install-PSResource -Name 'ManageEngine.ServiceDesk.OnPrem' -Repository PSGallery
```

You can then either import everything or if you want just import specifically what you need (the required `ManageEngine.ServiceDesk.OnPrem.Core` module should be automatically imported as well:

```powershell 
Import-Module ManageEngine.ServiceDesk.OnPrem.Requests
```

## Requirements

- PowerShell 7.0+
- ManageEngine ServiceDesk Plus on-premises (with REST API enabled)
- A Technician API key or Integration Key

## Quick start

You can bring your API key however you'd like, but I strongly recommend using the `Microsoft.Powershell.SecretManagement` or another secret managemet module to prevent secret leakage at the command line, especially in environments with PowerShell script block logging enabled.

```powershell
$key = Get-Secret -Name 'SdpTechnicianKey'
Connect-SDPService -BaseUri 'https://sdp.corp.local:8080' -TechnicianKey $key

# List open requests
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Open' }) -All

# Get a single request
Get-SDPRequest -Id '12345'

# Create a request
New-SDPRequest -Subject 'Cannot access VPN' -RequesterName 'Jane Smith' -PriorityName 'High'

# Update a request
Set-SDPRequest -Id '12345' -TechnicianName 'Bob Jones' -StatusName 'In Progress'

# Pipeline: close all resolved requests
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Resolved' }) -All |
    Set-SDPRequest -StatusName 'Closed'

# Add a note
New-SDPRequestNote -RequestId '12345' -Description 'Escalated to Tier 2.' -ShowToRequester

# Add a worklog
New-SDPRequestWorklog -RequestId '12345' -TimeSpentHours '1' -TimeSpentMinutes '30' -Description 'Troubleshooting session'

# Set a resolution
New-SDPRequestResolution -RequestId '12345' -Content 'Reset credentials. Issue resolved.'

# View and act on pending approvals
Get-SDPApproval
Approve-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Approved.'
Deny-SDPApproval   -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Missing justification.'

# Disconnect
Disconnect-SDPService
```

## Multi-portal installs

If your SDP instance hosts more than one portal, pass `-PortalId` when connecting:

```powershell
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -PortalId 2
```

The default portal ID is `1`.

## Self-signed certificates

Pass `-SkipCertificateCheck` to bypass SSL validation for instances with untrusted certificates:

```powershell
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -SkipCertificateCheck
```

## Documentation

Full functions reference is available in the [docs](docs/).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
