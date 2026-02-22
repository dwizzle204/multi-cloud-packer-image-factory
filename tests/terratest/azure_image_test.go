package terratest

import (
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestTerratestAzureImageInstance(t *testing.T) {
	t.Parallel()

	if !boolEnv("TERRATEST_ENABLE_AZURE") {
		t.Skip("set TERRATEST_ENABLE_AZURE=true to run Azure terratest")
	}

	imageID := requireEnvOrSkip(t, "AZURE_TEST_IMAGE_ID")
	resourceGroup := requireEnvOrSkip(t, "AZURE_TEST_RESOURCE_GROUP")
	subnetID := requireEnvOrSkip(t, "AZURE_TEST_SUBNET_ID")
	location := requireEnvOrSkip(t, "AZURE_TEST_LOCATION")
	osType := envOrDefault("TEST_OS_TYPE", "linux")

	vars := map[string]interface{}{
		"image_id":            imageID,
		"resource_group_name": resourceGroup,
		"subnet_id":           subnetID,
		"location":            location,
		"os_type":             osType,
		"vm_size":             envOrDefault("AZURE_TEST_VM_SIZE", "Standard_B1s"),
		"admin_username":      envOrDefault("AZURE_TEST_ADMIN_USERNAME", "packer"),
		"linux_ssh_public_key": envOrDefault("AZURE_TEST_LINUX_SSH_PUBLIC_KEY",
			"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDexampleplaceholder"),
		"windows_admin_password": envOrDefault("AZURE_TEST_WINDOWS_ADMIN_PASSWORD", ""),
	}

	if osType == "windows" && vars["windows_admin_password"].(string) == "" {
		t.Skip("windows os_type requires AZURE_TEST_WINDOWS_ADMIN_PASSWORD")
	}

	tfDir := filepath.Join("fixtures", "azure")
	opts := &terraform.Options{TerraformDir: tfDir, Vars: vars}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	vmID := terraform.Output(t, opts, "vm_id")
	require.NotEmpty(t, vmID)
}
