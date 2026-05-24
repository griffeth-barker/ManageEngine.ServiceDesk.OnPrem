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
| `ManageEngine.ServiceDesk.OnPrem.Changes` | Changes, notes, tasks, worklogs, deployment schedules, associations, and change config types (CAB, roles, risks, etc.) |
| `ManageEngine.ServiceDesk.OnPrem.Assets` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Cmdb` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Releases` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Problems` | Problems, dependencies, notes, tasks, assignments, worklogs, etc. |
| `ManageEngine.ServiceDesk.OnPrem.Projects` | *Future* |
| `ManageEngine.ServiceDesk.OnPrem.Admin` | Announcements, categories, departments, impacts, items, levels, modes, users,reminders, and other various helpdesk configuration |

Install the umbrella module to get everything:  

[![PSGallery Version](https://img.shields.io/powershellgallery/v/ManageEngine.ServiceDesk.OnPrem.png?style=for-the-badge&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/ManageEngine.ServiceDesk.OnPrem/0.1.2/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/ManageEngine.ServiceDesk.OnPrem.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/ManageEngine.ServiceDesk.OnPrem/0.1.2/)  

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

```powershell
$key = Get-Secret -Name 'SdpTechnicianKey'
Connect-SDPService -BaseUri 'https://sdp.corp.local:8080' -TechnicianKey $key

Get-SDPRequest -Id '12345'
Get-SDPChange  -Id '12345'

Disconnect-SDPService
```

See [EXAMPLES.md](EXAMPLES.md) for full usage examples across all modules.

## Documentation

Full functions reference is available in the [docs](docs/).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
