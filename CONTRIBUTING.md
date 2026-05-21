# Contributing

## Prerequisites

```powershell
Install-Module platyPS -Scope CurrentUser
Install-Module Pester  -Scope CurrentUser -Force
```

## Building

```powershell
# Generate docs + run unit tests + package
./build.ps1

# Individual tasks
./build.ps1 -Task Docs
./build.ps1 -Task Test
./build.ps1 -Task Package
```

## Integration tests

Integration tests require a live SDP instance:

```powershell
$env:SDP_BASE_URI       = 'https://sdp.corp.local:8080'
$env:SDP_TECHNICIAN_KEY = 'your-api-key'
./build.ps1 -Task IntegrationTest
```

## Adding a new function

1. Create `ServiceDesk.OnPrem.Requests/Public/Verb-SDPNoun.ps1`
2. Follow the `[CmdletBinding(SupportsShouldProcess)]` + `[OutputType('TypeName')]` pattern (use string literals for `OutputType`, not type literals)
3. Add the function name to `FunctionsToExport` in the `.psd1`
4. Add a corresponding class in `Classes/` if a new output type is needed (use next sequence number)
5. Run `./build.ps1 -Task Docs` to generate/update the Markdown help stubs in `docs/en-US/`
6. Fill in any `{{ ... }}` placeholders left in the generated Markdown
7. Add unit tests to `tests/ServiceDesk.OnPrem.Requests.Tests.ps1`

## Pull request guidelines

- Keep PRs focused — one feature or fix per PR
- New public functions require comment-based help and at least one unit test
- Run `./build.ps1` (all tasks) before submitting
- Use past-tense commit messages (e.g. "Added Get-SDPRequestResolution")
