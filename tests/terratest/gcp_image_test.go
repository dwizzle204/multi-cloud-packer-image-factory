package terratest

import (
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestTerratestGCPImageInstance(t *testing.T) {
	t.Parallel()

	if !boolEnv("TERRATEST_ENABLE_GCP") {
		t.Skip("set TERRATEST_ENABLE_GCP=true to run GCP terratest")
	}

	projectID := requireEnvOrSkip(t, "GCP_TEST_PROJECT_ID")
	zone := requireEnvOrSkip(t, "GCP_TEST_ZONE")
	imageName := requireEnvOrSkip(t, "GCP_TEST_IMAGE_NAME")

	vars := map[string]interface{}{
		"project_id":   projectID,
		"zone":         zone,
		"image_name":   imageName,
		"machine_type": envOrDefault("GCP_TEST_MACHINE_TYPE", "e2-micro"),
		"network":      envOrDefault("GCP_TEST_NETWORK", "default"),
	}

	tfDir := filepath.Join("fixtures", "gcp")
	opts := &terraform.Options{TerraformDir: tfDir, Vars: vars}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	instanceName := terraform.Output(t, opts, "instance_name")
	require.NotEmpty(t, instanceName)
}
