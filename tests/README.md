# Tests

This directory contains:

- `smoke/`: in-instance verification for built Linux/Windows images.
- `compliance/`: summary generation from manifest + CIS marker artifacts.
- `ci/`: repository/workflow static checks for template integrity.
- `terratest/`: example Terraform + Terratest integration tests for AWS/Azure/GCP image launch validation.
- `run-all.sh`: local runner for static checks.
 - `Makefile` (repo root): shortcuts for local test commands.

## Quick usage

Run local static checks:

```bash
bash tests/run-all.sh
```

Run Linux smoke test on a VM created from a built image:

```bash
bash tests/smoke/linux-smoke.sh
```

Run Linux compliance summary on the same VM:

```bash
bash tests/compliance/summarize-linux.sh
```

Run Windows smoke test in PowerShell on a VM created from a built image:

```powershell
pwsh -File tests/smoke/windows-smoke.ps1
```

Run Windows compliance summary in PowerShell:

```powershell
pwsh -File tests/compliance/summarize-windows.ps1
```

Run Terratest examples (environment-gated):

```bash
cd tests/terratest
go test -v ./...
```

or from repo root:

```bash
make terratest
```
