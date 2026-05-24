# Contributing

Development `ManageEngine.ServiceDesk.OnPrem` and its sub-modules is based on the API reference collection available [here](https://www.postman.com/servicedeskplus/servicedesk-plus-api/overview?sideView=agentMode). The ultimate goal is 100% coverage of the API specification in a manner that users of the modules can consistently rely upon.

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
| `SDP_TEST_REQUEST_ID` | Existing request ID to use for single-record read tests (Requests) |
| `SDP_TEST_REQUESTER_NAME` | Requester name to supply when creating test requests (set if your instance marks requester as mandatory) |
| `SDP_TEST_CATEGORY_NAME` | Category name to supply when creating test requests (set if your instance marks category as mandatory) |
| `SDP_TEST_PRIORITY_NAME` | Priority name to supply when creating test requests or changes (set if your instance marks priority as mandatory) |
| `SDP_TEST_OWNER_NAME` | Technician name for worklog owner (set if your instance marks worklog owner as mandatory) |
| `SDP_TEST_CHANGE_ID` | Existing change ID to use for single-record read tests (Changes) |
| `SDP_TEST_CHANGE_TYPE_NAME` | Change type name to supply when creating test changes (set if your instance marks change type as mandatory) |
| `SDP_TEST_TECHNICIAN_NAME` | Technician name to supply when creating test changes (set if your instance marks technician as mandatory) |

The lifecycle tests call `New-SDPRequest` / `New-SDPChange` with only the minimum required parameters by default. If your SDP instance enforces additional mandatory fields, the create step will fail with error code `4012`. Set the corresponding env vars above to satisfy those requirements.

## Repo layout

```
modules/
  ManageEngine.ServiceDesk.OnPrem/           # umbrella module
  ManageEngine.ServiceDesk.OnPrem.Core/      # auth, session, HTTP transport
  ManageEngine.ServiceDesk.OnPrem.Requests/  # requests, notes, tasks, worklogs, approvals
  ManageEngine.ServiceDesk.OnPrem.Changes/   # changes, notes, tasks, worklogs, deployment schedules, associations
docs/
  ManageEngine.ServiceDesk.OnPrem.Core/en-US/
  ManageEngine.ServiceDesk.OnPrem.Requests/en-US/
  ManageEngine.ServiceDesk.OnPrem.Changes/en-US/
tests/
  ManageEngine.ServiceDesk.OnPrem.Core.Tests.ps1
  ManageEngine.ServiceDesk.OnPrem.Requests.Tests.ps1
  ManageEngine.ServiceDesk.OnPrem.Changes.Tests.ps1
  Integration/
    SDPRequests.Integration.Tests.ps1
    SDPChanges.Integration.Tests.ps1
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

## Branching

`main` is the stable, always-releasable branch. Direct commits to `main` are not allowed; all changes go through a pull request.

### Branch naming

| Prefix | Use for |
|---|---|
| `feature/` | New cmdlets, new sub-modules, new capabilities |
| `fix/` | Bug fixes |
| `chore/` | Maintenance — dependency updates, CI changes, doc-only edits |

For changes scoped to a single sub-module, include the module slug after the prefix so it is obvious which module a branch touches:

```
feature/requests/get-sdprequeststatus
fix/core/invoke-sdprestmethod-timeout
chore/requests/update-pester-config
```

For changes that touch multiple modules or the umbrella module, omit the slug:

```
feature/add-assets-module
chore/update-all-copyright-headers
```

## Pull requests

### Target branch

All PRs target `main`.

### Title format

Prefix the title with the affected module in square brackets, then a past-tense description:

```
[Core] Added retry logic to Invoke-SDPRestMethod
[Requests] Fixed worklog date serialization for non-UTC timezones
[Requests] Added Get-SDPRequestStatus
[All] Updated copyright year to 2027
```

Use `[All]` when the change spans more than one module.

### Checklist before opening a PR

1. Run `./build.ps1` (all tasks pass) — unit tests are also enforced automatically by CI
2. New public functions have comment-based help and at least one Pester unit test
3. Version numbers bumped as needed (see **Versioning** below)
4. `RequiredModules` constraints updated in any dependent `.psd1` files if a sub-module version changed
5. PR description notes which modules are affected and summarises any version changes

### PR description template

```
## What changed
<bullet list of changes>

## Modules affected
- ManageEngine.ServiceDesk.OnPrem.Core — x.y.z → x.y.z+1
- ManageEngine.ServiceDesk.OnPrem.Requests — unchanged

## Testing
<what was run and what passed>
```

## GitHub Actions

Two workflows run automatically — no manual steps are required after opening or merging a PR.

### CI (`ci.yml`)

Runs on every pull request targeting `main`. Installs prerequisites and executes `./build.ps1 -Task Test`. The PR is blocked from merging if any unit test fails. Test results are uploaded as a workflow artifact on every run, including failures.

### Release (`release.yml`)

Runs on every push to `main` (i.e., after a PR is merged). For each module whose `.psd1` `ModuleVersion` differs from the previous commit, the workflow:

1. Builds distribution packages via `./build.ps1 -Task Package`
2. Creates a scoped git tag (`ManageEngine.ServiceDesk.OnPrem.Core/vX.Y.Z`)
3. Publishes a GitHub release with the module zip attached
4. Publishes the module to the PowerShell Gallery

Modules are processed in dependency order (Core first, then sub-modules, then the umbrella) so that PSGallery `RequiredModules` constraints are satisfied. If no `.psd1` versions changed the workflow exits early without creating any tags or releases.

> **You do not need to manually create tags, push to PSGallery, or create GitHub releases.** Bumping `ModuleVersion` in the relevant `.psd1` files as part of your PR is the only trigger needed.

## Versioning

Each module versions independently via its `.psd1` `ModuleVersion` field. Follow [Semantic Versioning](https://semver.org/):

| Change type | Version component |
|---|---|
| Breaking change to a public cmdlet or type | Major (`x.0.0`) |
| New public cmdlet or parameter | Minor (`0.x.0`) |
| Bug fix, docs, internal refactor | Patch (`0.0.x`) |

Rules for keeping versions consistent:

- When a sub-module version bumps, update the `RequiredModules` minimum version in every `.psd1` that depends on it.
- Bump the umbrella module (`ManageEngine.ServiceDesk.OnPrem`) version whenever any sub-module version changes, so that `Install-Module ManageEngine.ServiceDesk.OnPrem` always pulls the correct dependency versions.
- Version bumps are part of the same PR as the change — do not use a separate "version bump" PR.

## Tagging

Tags are created after a PR is merged to `main`. Because modules version independently, each release gets its own tag scoped to the module name:

```
ManageEngine.ServiceDesk.OnPrem/v0.2.1
ManageEngine.ServiceDesk.OnPrem.Core/v0.2.0
ManageEngine.ServiceDesk.OnPrem.Requests/v0.2.0
```

### Finding the tag for a given module version

```bash
git tag --list 'ManageEngine.ServiceDesk.OnPrem.Core/*'
git tag --list 'ManageEngine.ServiceDesk.OnPrem.Requests/*'
```
