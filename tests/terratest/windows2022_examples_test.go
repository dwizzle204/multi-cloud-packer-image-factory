package terratest

import (
	"strings"
	"testing"
	"time"

	terratestssh "github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/stretchr/testify/require"
)

func windowsHostFromEnv(t *testing.T) terratestssh.Host {
	t.Helper()
	return sshHostFromEnv(
		t,
		"TERRATEST_WINDOWS_HOST",
		"TERRATEST_WINDOWS_SSH_USER",
		"TERRATEST_WINDOWS_SSH_PRIVATE_KEY_PATH",
		"TERRATEST_WINDOWS_SSH_PORT",
	)
}

func TestExampleWindows2022SmokeOverSSH(t *testing.T) {
	t.Parallel()
	requireBoolEnvEnabledOrSkip(t, "TERRATEST_ENABLE_WINDOWS_EXAMPLES")

	host := windowsHostFromEnv(t)
	terratestssh.CheckSshConnectionWithRetry(t, host, 30, 10*time.Second)

	caption := terratestssh.CheckSshCommand(t, host,
		"powershell -NoProfile -Command \"(Get-CimInstance Win32_OperatingSystem).Caption\"")
	require.Contains(t, caption, "Windows Server 2022")

	cisMarkerExists := terratestssh.CheckSshCommand(t, host,
		"powershell -NoProfile -Command \"Test-Path 'C:\\ProgramData\\ImageFactory\\cis_applied.txt'\"")
	require.Contains(t, strings.ToLower(cisMarkerExists), "true")

	manifestVersion := terratestssh.CheckSshCommand(t, host,
		"powershell -NoProfile -Command \"(Get-Content 'C:\\ProgramData\\ImageFactory\\manifest.json' -Raw | ConvertFrom-Json).image_version\"")
	require.NotEmpty(t, strings.TrimSpace(manifestVersion))
}

func TestExampleWindows2022WinRMService(t *testing.T) {
	t.Parallel()
	requireBoolEnvEnabledOrSkip(t, "TERRATEST_ENABLE_WINDOWS_EXAMPLES")

	host := windowsHostFromEnv(t)
	terratestssh.CheckSshConnectionWithRetry(t, host, 30, 10*time.Second)

	winrmStatus := terratestssh.CheckSshCommand(t, host,
		"powershell -NoProfile -Command \"(Get-Service -Name WinRM).Status\"")
	require.Equal(t, "Running", strings.TrimSpace(winrmStatus))
}
