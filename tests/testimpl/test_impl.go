package testimpl

import (
	"context"
	"strings"
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
		topicArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")

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
		arn := terraform.OutputContext(t, context.Background(), opts, "arn")
		name := terraform.OutputContext(t, context.Background(), opts, "name")
		id := terraform.OutputContext(t, context.Background(), opts, "id")
		owner := terraform.OutputContext(t, context.Background(), opts, "owner")
		arnParts := strings.SplitN(arn, ":", 6)
		require.Len(t, arnParts, 6, "ARN should have 6 sections")
		nameFromArn := arnParts[5]
		ownerFromArn := arnParts[4]

		assert.Equal(t, arn, id, "id should equal arn")
		assert.Contains(t, arn, "arn:aws:sns:", "ARN should have SNS format")
		assert.Equal(t, nameFromArn, name, "name should match ARN topic name")
		assert.Equal(t, ownerFromArn, owner, "owner should match ARN account ID")
	})

	t.Run("TestSNSTopicViaAPI", func(t *testing.T) {
		client := getSNSClient(t)
		topicArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")

		out, err := client.GetTopicAttributes(context.Background(), &sns.GetTopicAttributesInput{
			TopicArn: &topicArn,
		})
		require.NoError(t, err, "GetTopicAttributes should succeed")
		require.NotNil(t, out.Attributes, "Topic attributes should be present")

		attrs := out.Attributes
		kmsKeyId, ok := attrs["KmsMasterKeyId"]
		require.True(t, ok, "KmsMasterKeyId must be present - encryption may not be configured")
		require.NotEmpty(t, kmsKeyId, "KMS key ID should be set")

		expectedKmsArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "kms_key_arn")
		assert.Equal(t, expectedKmsArn, kmsKeyId, "KMS key should match the key provisioned by Terraform")

		expectedArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		assert.Equal(t, expectedArn, topicArn, "Topic ARN should match Terraform output")
	})
}

func ptr(s string) *string {
	return &s
}
