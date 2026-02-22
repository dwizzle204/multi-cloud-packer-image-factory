SHELL := /bin/bash

.PHONY: help test test-static test-smoke-linux test-compliance-linux terratest terratest-aws terratest-azure terratest-gcp terratest-rhel8 terratest-rhel9 terratest-win2022

help:
	@echo "Available targets:"
	@echo "  make test               - Run repository static checks and local script validation"
	@echo "  make test-static        - Alias for make test"
	@echo "  make test-smoke-linux   - Run Linux smoke script locally/on a Linux image VM"
	@echo "  make test-compliance-linux - Run Linux compliance summary script"
	@echo "  make terratest          - Run all Terratest packages (env-gated tests skip by default)"
	@echo "  make terratest-aws      - Run AWS Terratest example (requires TERRATEST_ENABLE_AWS + env vars)"
	@echo "  make terratest-azure    - Run Azure Terratest example (requires TERRATEST_ENABLE_AZURE + env vars)"
	@echo "  make terratest-gcp      - Run GCP Terratest example (requires TERRATEST_ENABLE_GCP + env vars)"
	@echo "  make terratest-rhel8    - Run RHEL8 SSH example (requires TERRATEST_ENABLE_RHEL_EXAMPLES + env vars)"
	@echo "  make terratest-rhel9    - Run RHEL9 SSH example (requires TERRATEST_ENABLE_RHEL_EXAMPLES + env vars)"
	@echo "  make terratest-win2022  - Run Windows 2022 SSH examples (requires TERRATEST_ENABLE_WINDOWS_EXAMPLES + env vars)"

test: test-static

test-static:
	bash tests/run-all.sh

test-smoke-linux:
	bash tests/smoke/linux-smoke.sh

test-compliance-linux:
	bash tests/compliance/summarize-linux.sh

terratest:
	cd tests/terratest && go test -v ./...

terratest-aws:
	cd tests/terratest && go test -v -run TestTerratestAWSImageInstance ./...

terratest-azure:
	cd tests/terratest && go test -v -run TestTerratestAzureImageInstance ./...

terratest-gcp:
	cd tests/terratest && go test -v -run TestTerratestGCPImageInstance ./...

terratest-rhel8:
	cd tests/terratest && go test -v -run TestExampleRHEL8SmokeOverSSH ./...

terratest-rhel9:
	cd tests/terratest && go test -v -run TestExampleRHEL9SmokeOverSSH ./...

terratest-win2022:
	cd tests/terratest && go test -v -run 'TestExampleWindows2022SmokeOverSSH|TestExampleWindows2022WinRMService' ./...
