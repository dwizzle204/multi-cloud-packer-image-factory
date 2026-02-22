package terratest

import (
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestTerratestAWSImageInstance(t *testing.T) {
	t.Parallel()

	if !boolEnv("TERRATEST_ENABLE_AWS") {
		t.Skip("set TERRATEST_ENABLE_AWS=true to run AWS terratest")
	}

	awsRegion := requireEnvOrSkip(t, "AWS_TEST_REGION")
	imageID := requireEnvOrSkip(t, "AWS_TEST_IMAGE_ID")

	tfDir := filepath.Join("fixtures", "aws")
	opts := &terraform.Options{
		TerraformDir: tfDir,
		Vars: map[string]interface{}{
			"region":             awsRegion,
			"image_id":           imageID,
			"instance_type":      envOrDefault("AWS_TEST_INSTANCE_TYPE", "t3.micro"),
			"subnet_id":          envOrDefault("AWS_TEST_SUBNET_ID", ""),
			"security_group_ids": []string{},
		},
	}

	if sg := envOrDefault("AWS_TEST_SECURITY_GROUP_ID", ""); sg != "" {
		opts.Vars["security_group_ids"] = []string{sg}
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	instanceID := terraform.Output(t, opts, "instance_id")
	require.NotEmpty(t, instanceID)
}
