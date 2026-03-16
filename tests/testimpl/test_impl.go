package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func getSNSClient(t *testing.T) *sns.Client {
	cfg, err := config.LoadDefaultConfig(context.Background())
	require.NoError(t, err, "Failed to load AWS config")
	return sns.NewFromConfig(cfg)
}

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	TestComposableCompleteReadonly(t, ctx)

	t.Run("TestSNSPublish", func(t *testing.T) {
		client := getSNSClient(t)
		topicArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "arn")

		_, err := client.Publish(context.Background(), &sns.PublishInput{
			TopicArn: &topicArn,
			Message:  ptr("Test message from Terratest"),
		})
		require.NoError(t, err, "SNS Publish should succeed")
	})
}

func TestComposableCompleteReadonly(t *testing.T, ctx types.TestContext) {
	t.Run("TestTerraformOutputs", func(t *testing.T) {
		opts := ctx.TerratestTerraformOptions()
		arn := terraform.Output(t, opts, "arn")
		name := terraform.Output(t, opts, "name")
		id := terraform.Output(t, opts, "id")
		owner := terraform.Output(t, opts, "owner")

		assert.Equal(t, arn, id, "id should equal arn")
		assert.Contains(t, arn, "arn:aws:sns:", "ARN should have SNS format")
		assert.NotEmpty(t, name, "name should be set")
		assert.NotEmpty(t, owner, "owner should be set")
	})

	t.Run("TestSNSTopicViaAPI", func(t *testing.T) {
		client := getSNSClient(t)
		topicArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "arn")

		out, err := client.GetTopicAttributes(context.Background(), &sns.GetTopicAttributesInput{
			TopicArn: &topicArn,
		})
		require.NoError(t, err, "GetTopicAttributes should succeed")
		require.NotNil(t, out.Attributes, "Topic attributes should be present")

		attrs := out.Attributes
		kmsKeyId, ok := attrs["KmsMasterKeyId"]
		require.True(t, ok, "KmsMasterKeyId must be present - encryption may not be configured")
		require.NotEmpty(t, kmsKeyId, "KMS key ID should be set")

		expectedKmsArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "kms_key_arn")
		assert.Equal(t, expectedKmsArn, kmsKeyId, "KMS key should match the key provisioned by Terraform")

		expectedArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "arn")
		assert.Equal(t, expectedArn, topicArn, "Topic ARN should match Terraform output")
	})
}

func ptr(s string) *string {
	return &s
}
