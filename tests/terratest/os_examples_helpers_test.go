package terratest

import (
	"os"
	"strconv"
	"strings"
	"testing"

	terratestssh "github.com/gruntwork-io/terratest/modules/ssh"
)

func requireBoolEnvEnabledOrSkip(t *testing.T, key string) {
	t.Helper()
	if !boolEnv(key) {
		t.Skipf("set %s=true to run this example test", key)
	}
}

func sshHostFromEnv(t *testing.T, hostEnv, userEnv, keyPathEnv, portEnv string) terratestssh.Host {
	t.Helper()

	host := requireEnvOrSkip(t, hostEnv)
	user := requireEnvOrSkip(t, userEnv)
	keyPath := requireEnvOrSkip(t, keyPathEnv)

	keyBytes, err := os.ReadFile(keyPath)
	if err != nil {
		t.Fatalf("failed to read SSH private key from %s: %v", keyPath, err)
	}

	sshHost := terratestssh.Host{
		Hostname:    host,
		SshUserName: user,
		SshKeyPair: &terratestssh.KeyPair{
			PrivateKey: string(keyBytes),
		},
	}

	if portRaw := strings.TrimSpace(os.Getenv(portEnv)); portRaw != "" {
		p, convErr := strconv.Atoi(portRaw)
		if convErr != nil {
			t.Fatalf("invalid %s value %q: %v", portEnv, portRaw, convErr)
		}
		sshHost.CustomPort = p
	}

	return sshHost
}
