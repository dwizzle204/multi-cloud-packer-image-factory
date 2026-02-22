package terratest

import (
	"strings"
	"testing"
	"time"

	terratestssh "github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/stretchr/testify/require"
)

func requireRHELTargetVersionOrSkip(t *testing.T, expected string) {
	t.Helper()
	actual := strings.TrimSpace(envOrDefault("TERRATEST_RHEL_TARGET_VERSION", ""))
	if actual == "" {
		t.Skip("set TERRATEST_RHEL_TARGET_VERSION to 8 or 9")
	}
	if actual != expected {
		t.Skipf("RHEL target version is %s; skipping RHEL%s example", actual, expected)
	}
}

func rhelHostFromEnv(t *testing.T) terratestssh.Host {
	t.Helper()
	return sshHostFromEnv(
		t,
		"TERRATEST_RHEL_HOST",
		"TERRATEST_RHEL_SSH_USER",
		"TERRATEST_RHEL_SSH_PRIVATE_KEY_PATH",
		"TERRATEST_RHEL_SSH_PORT",
	)
}

func TestExampleRHEL8SmokeOverSSH(t *testing.T) {
	t.Parallel()
	requireBoolEnvEnabledOrSkip(t, "TERRATEST_ENABLE_RHEL_EXAMPLES")
	requireRHELTargetVersionOrSkip(t, "8")

	host := rhelHostFromEnv(t)
	terratestssh.CheckSshConnectionWithRetry(t, host, 30, 10*time.Second)

	osRelease := terratestssh.CheckSshCommand(t, host, "cat /etc/os-release")
	require.Contains(t, osRelease, `VERSION_ID="8"`)

	marker := terratestssh.CheckSshCommand(t, host, "cat /var/log/image_factory/cis_applied.txt")
	require.Contains(t, strings.ToLower(marker), "cis applied")

	manifestName := terratestssh.CheckSshCommand(t, host, "python3 - <<'PY'\nimport json\nprint(json.load(open('/var/log/image_factory/manifest.json'))['image_name'])\nPY")
	require.NotEmpty(t, strings.TrimSpace(manifestName))
}

func TestExampleRHEL9SmokeOverSSH(t *testing.T) {
	t.Parallel()
	requireBoolEnvEnabledOrSkip(t, "TERRATEST_ENABLE_RHEL_EXAMPLES")
	requireRHELTargetVersionOrSkip(t, "9")

	host := rhelHostFromEnv(t)
	terratestssh.CheckSshConnectionWithRetry(t, host, 30, 10*time.Second)

	osRelease := terratestssh.CheckSshCommand(t, host, "cat /etc/os-release")
	require.Contains(t, osRelease, `VERSION_ID="9"`)

	dnfVersion := terratestssh.CheckSshCommand(t, host, "dnf --version | head -n1")
	require.NotEmpty(t, strings.TrimSpace(dnfVersion))

	manifestChannel := terratestssh.CheckSshCommand(t, host, "python3 - <<'PY'\nimport json\nprint(json.load(open('/var/log/image_factory/manifest.json'))['channel'])\nPY")
	require.NotEmpty(t, strings.TrimSpace(manifestChannel))
}
