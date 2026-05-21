# ServiceDesk.OnPrem.Requests

A PowerShell module for the [ManageEngine ServiceDesk Plus On-Prem](https://www.manageengine.com/products/service-desk/on-premises/) REST API — Requests surface.

Provides full CRUD coverage for requests, notes, tasks, worklogs, approval levels, and approvals according to Zoho's API reference collection. Authentication uses technician or integration keys.

> **DISCLAIMER:**  
> This module is not affiliated with nor supported by Zoho/ManageEngine.
> This code should be considered experimental. You should understand the code that you choose to run on your systems. This code should not be considered production ready as long as this banner is present and/or the module version is < 1.0.0.

## Requirements

- PowerShell 7.0 or later
- ManageEngine ServiceDesk Plus on-premises (with REST API enabled)
- A Technician API key

## Installation

```powershell
# Via PowerShell Gallery
Install-PSResource -Name 'ServiceDesk.OnPrem.Requests' -Repository PSGallery

# Via Download
# Download the project and expand the archive, then run
Import-Module ./ServiceDesk.OnPrem.Requests/ServiceDesk.OnPrem.Requests.psd1
```

## Quick start

You are free to pass your technician or integration key however you please, but I recommend using the SecretsManagement module:

```powershell
# Connect (API key stored as SecureString)
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

# Pipeline: close all requests resolved more than 30 days ago
Get-SDPRequest -Filter @(@{ field = 'status.name'; condition = 'eq'; value = 'Resolved' }) -All |
    Set-SDPRequest -StatusName 'Closed'

# Add a note
New-SDPRequestNote -RequestId '12345' -Description 'Escalated to Tier 2.' -ShowToRequester

# Add a worklog
New-SDPRequestWorklog -RequestId '12345' -TimeSpentHours '1' -TimeSpentMinutes '30' -Description 'Troubleshooting session'

# Set a resolution
New-SDPRequestResolution -RequestId '12345' -Content 'Reset credentials. Issue resolved.'

# View pending approvals
Get-SDPApproval

# Approve / deny
Approve-SDPApproval -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Approved.'
Deny-SDPApproval   -RequestId '12345' -LevelNumber 1 -ApprovalId '1' -Comments 'Missing justification.'

# Disconnect
Disconnect-SDPService
```

## Available Commands

| Noun | Get | New | Set | Remove |
|---|---|---|---|---|
| SDPRequest | ✓ | ✓ | ✓ | ✓ |
| SDPRequestNote | ✓ | ✓ | ✓ | ✓ |
| SDPRequestTask | ✓ | ✓ | ✓ | ✓ |
| SDPRequestWorklog | ✓ | ✓ | ✓ | ✓ |
| SDPRequestResolution | ✓ | ✓ | — | — |
| SDPApproval | ✓ | — | — | — |

Additional: `Connect-SDPService`, `Disconnect-SDPService`, `Approve-SDPApproval`, `Deny-SDPApproval`

## Documentation

Full cmdlet reference: [docs/en-US/](docs/en-US/) (generated via PlatyPS — run `./build.ps1 -Task Docs` first).

## Multi-portal installs

If your SDP instance hosts more than one portal, pass `-PortalId` when connecting:

```powershell
Connect-SDPService -BaseUri 'https://sdp.corp.local' -TechnicianKey $key -PortalId 2
```

The default portal ID is `1`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).


