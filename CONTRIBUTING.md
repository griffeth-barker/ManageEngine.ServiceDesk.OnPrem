# Contributing

## Prerequisites

```powershell
Install-Module platyPS -Scope CurrentUser
Install-Module Pester  -Scope CurrentUser -Force
```

## Building

```powershell
# Generate docs + run unit tests + package (all modules)
./build.ps1

# Target a specific module
./build.ps1 -Module Core
./build.ps1 -Module Requests

# Individual tasks
./build.ps1 -Task Docs
./build.ps1 -Task Test
./build.ps1 -Task Package
```

## Integration tests

Integration tests require a live SDP instance and a secret named `ZohoSdpOnPremApiKey` in a Microsoft.PowerShell.SecretManagement vault:

```powershell
$env:SDP_BASE_URI = 'https://sdp.corp.local:8080'
./build.ps1 -Task IntegrationTest
```

Pass `-SkipCertificateCheck` for instances with self-signed certificates:

```powershell
./build.ps1 -Task IntegrationTest -SkipCertificateCheck
```

### Optional environment variables

| Variable | Purpose |
|---|---|
| `SDP_PORTAL_ID` | Portal ID — defaults to `1` |
| `SDP_TEST_REQUEST_ID` | Existing request ID to use for single-record read tests |
| `SDP_TEST_REQUESTER_NAME` | Requester name to supply when creating test requests (set if your instance marks requester as mandatory) |
| `SDP_TEST_CATEGORY_NAME` | Category name to supply when creating test requests (set if your instance marks category as mandatory) |
| `SDP_TEST_PRIORITY_NAME` | Priority name to supply when creating test requests (set if your instance marks priority as mandatory) |
| `SDP_TEST_OWNER_NAME` | Technician name for worklog owner (set if your instance marks worklog owner as mandatory) |

The lifecycle tests (`Request lifecycle` describe block) call `New-SDPRequest` with only a subject and description by default. If your SDP instance enforces additional mandatory fields, the create step will fail with error code `4012`. Set the corresponding env vars above to satisfy those requirements.

## Repo layout

```
modules/
  ManageEngine.ServiceDesk.OnPrem/           # umbrella module
  ManageEngine.ServiceDesk.OnPrem.Core/      # auth, session, HTTP transport
  ManageEngine.ServiceDesk.OnPrem.Requests/  # requests, notes, tasks, worklogs, approvals
docs/
  ManageEngine.ServiceDesk.OnPrem.Core/en-US/
  ManageEngine.ServiceDesk.OnPrem.Requests/en-US/
tests/
  ManageEngine.ServiceDesk.OnPrem.Core.Tests.ps1
  ManageEngine.ServiceDesk.OnPrem.Requests.Tests.ps1
  Integration/
```

## Adding a function to an existing module

1. Create `modules/<ModuleName>/Public/Verb-SDPNoun.ps1`
2. Follow the `[CmdletBinding(SupportsShouldProcess)]` + `[OutputType('TypeName')]` pattern — use string literals for `OutputType`, not type literals
3. Add the function name to `FunctionsToExport` in the module's `.psd1`
4. If a new output type is needed, add a class file to `modules/<ModuleName>/Classes/` using the next sequence number
5. Run `./build.ps1 -Task Docs -Module <Core|Requests>` to generate/update the Markdown help
6. Fill in any `{{ ... }}` placeholders in the generated Markdown
7. Add unit tests to `tests/<ModuleName>.Tests.ps1`

## Adding a new sub-module

1. Create `modules/ManageEngine.ServiceDesk.OnPrem.<Name>/` with `Classes/`, `Public/`, a `.psm1`, and a `.psd1`
2. Set `RequiredModules = @(@{ ModuleName = 'ManageEngine.ServiceDesk.OnPrem.Core'; ModuleVersion = '...' })` in the `.psd1`
3. Add the new module to `RequiredModules` in the umbrella `ManageEngine.ServiceDesk.OnPrem.psd1`
4. Add the module name to `$allModules` in `build.ps1`
5. Create a corresponding docs folder at `docs/ManageEngine.ServiceDesk.OnPrem.<Name>/en-US/`
6. Create a test file at `tests/ManageEngine.ServiceDesk.OnPrem.<Name>.Tests.ps1`

## Pull request guidelines

- Keep PRs focused — one feature or fix per PR
- New public functions require comment-based help and at least one unit test
- Run `./build.ps1` (all tasks) before submitting
- Use past-tense commit messages (e.g. "Added Get-SDPRequestResolution")
