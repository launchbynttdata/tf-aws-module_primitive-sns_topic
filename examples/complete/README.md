# Complete Example

This example creates an SNS topic with customer-managed KMS encryption (security-first configuration).

## Usage

```hcl
data "aws_region" "current" {}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length

  region                = join("", split("-", data.aws_region.current.name))
  use_azure_region_abbr = false
}

resource "aws_kms_key" "sns" {
  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

module "sns_topic" {
  source = "../.."

  name        = module.resource_names["sns_topic"].standard
  name_prefix = var.name_prefix

  display_name    = var.display_name
  policy          = var.policy
  delivery_policy = var.delivery_policy

  kms_master_key_id = aws_kms_key.sns.arn
  signature_version = var.signature_version
  tracing_config    = var.tracing_config

  fifo_topic                 = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  archive_policy              = var.archive_policy
  fifo_throughput_scope       = var.fifo_throughput_scope

  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate  = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn     = var.application_failure_feedback_role_arn

  http_success_feedback_role_arn    = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn    = var.http_failure_feedback_role_arn

  lambda_success_feedback_role_arn    = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn    = var.lambda_failure_feedback_role_arn

  sqs_success_feedback_role_arn    = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn    = var.sqs_failure_feedback_role_arn

  firehose_success_feedback_role_arn    = var.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = var.firehose_success_feedback_sample_rate
  firehose_failure_feedback_role_arn    = var.firehose_failure_feedback_role_arn

  tags = var.tags
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| logical_product_family | Logical product family for resource naming. | `string` | n/a | yes |
| logical_product_service | Logical product service for resource naming. | `string` | n/a | yes |
| class_env | Class environment for resource naming (e.g., dev, prod). | `string` | n/a | yes |
| instance_env | Instance environment for resource naming. | `number` | n/a | yes |
| instance_resource | Instance resource for resource naming. | `number` | n/a | yes |
| resource_names_map | Map of resource types to naming configuration. | `map(object({name=string,max_length=number}))` | n/a | yes |
| display_name | The display name for the SNS topic. | `string` | `null` | no |
| policy | The fully-formed AWS policy as JSON for the SNS topic. | `string` | `null` | no |
| delivery_policy | The SNS delivery policy. | `string` | `null` | no |
| signature_version | The signature version for the topic (1 for SHA1 or 2 for SHA256). | `string` | `null` | no |
| tracing_config | Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active. | `string` | `null` | no |
| fifo_topic | Boolean indicating whether or not to create a FIFO topic. | `bool` | `false` | no |
| content_based_deduplication | Enables content-based deduplication for FIFO topics. | `bool` | `null` | no |
| archive_policy | The message archive policy for FIFO topics. | `string` | `null` | no |
| fifo_throughput_scope | Enables higher throughput for FIFO topics. Valid values: Topic, MessageGroup. | `string` | `null` | no |
| application_success_feedback_role_arn | The IAM role permitted to receive success feedback (application protocol). | `string` | `null` | no |
| application_success_feedback_sample_rate | Percentage of success to sample (0-100) for application protocol. | `number` | `null` | no |
| application_failure_feedback_role_arn | IAM role for failure feedback (application protocol). | `string` | `null` | no |
| http_success_feedback_role_arn | The IAM role permitted to receive success feedback (HTTP protocol). | `string` | `null` | no |
| http_success_feedback_sample_rate | Percentage of success to sample (0-100) for HTTP protocol. | `number` | `null` | no |
| http_failure_feedback_role_arn | IAM role for failure feedback (HTTP protocol). | `string` | `null` | no |
| lambda_success_feedback_role_arn | The IAM role permitted to receive success feedback (Lambda protocol). | `string` | `null` | no |
| lambda_success_feedback_sample_rate | Percentage of success to sample (0-100) for Lambda protocol. | `number` | `null` | no |
| lambda_failure_feedback_role_arn | IAM role for failure feedback (Lambda protocol). | `string` | `null` | no |
| sqs_success_feedback_role_arn | The IAM role permitted to receive success feedback (SQS protocol). | `string` | `null` | no |
| sqs_success_feedback_sample_rate | Percentage of success to sample (0-100) for SQS protocol. | `number` | `null` | no |
| sqs_failure_feedback_role_arn | IAM role for failure feedback (SQS protocol). | `string` | `null` | no |
| firehose_success_feedback_role_arn | The IAM role permitted to receive success feedback (Firehose protocol). | `string` | `null` | no |
| firehose_success_feedback_sample_rate | Percentage of success to sample (0-100) for Firehose protocol. | `number` | `null` | no |
| firehose_failure_feedback_role_arn | IAM role for failure feedback (Firehose protocol). | `string` | `null` | no |
| tags | Map of tags to assign to the SNS topic. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the resource (same as the ARN). |
| arn | The ARN of the SNS topic. |
| name | The name of the SNS topic. |
| owner | The AWS Account ID of the SNS topic owner. |
| beginning_archive_time | The oldest timestamp at which a FIFO topic subscriber can start a replay. |
| tags_all | Map of tags assigned to the resource, including those inherited from the provider. |
| kms_key_arn | The ARN of the KMS key used for SNS topic encryption. |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_sns_topic"></a> [sns\_topic](#module\_sns\_topic) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family for resource naming. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service for resource naming. | `string` | n/a | yes |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Class environment for resource naming (e.g., dev, prod). | `string` | n/a | yes |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment for resource naming. | `number` | n/a | yes |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource for resource naming. | `number` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of resource types to naming configuration. | <pre>map(object({<br/>    name       = string<br/>    max_length = number<br/>  }))</pre> | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with name. Set to null when using name. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the SNS topic. | `string` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The fully-formed AWS policy as JSON for the SNS topic. | `string` | `null` | no |
| <a name="input_delivery_policy"></a> [delivery\_policy](#input\_delivery\_policy) | The SNS delivery policy. | `string` | `null` | no |
| <a name="input_signature_version"></a> [signature\_version](#input\_signature\_version) | The signature version for the topic (1 for SHA1 or 2 for SHA256). | `string` | `null` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active. | `string` | `null` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | Boolean indicating whether or not to create a FIFO topic. | `bool` | `false` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Enables content-based deduplication for FIFO topics. | `bool` | `null` | no |
| <a name="input_archive_policy"></a> [archive\_policy](#input\_archive\_policy) | The message archive policy for FIFO topics. | `string` | `null` | no |
| <a name="input_fifo_throughput_scope"></a> [fifo\_throughput\_scope](#input\_fifo\_throughput\_scope) | Enables higher throughput for FIFO topics. Valid values: Topic, MessageGroup. | `string` | `null` | no |
| <a name="input_application_success_feedback_role_arn"></a> [application\_success\_feedback\_role\_arn](#input\_application\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback (application protocol). | `string` | `null` | no |
| <a name="input_application_success_feedback_sample_rate"></a> [application\_success\_feedback\_sample\_rate](#input\_application\_success\_feedback\_sample\_rate) | Percentage of success to sample (0-100) for application protocol. | `number` | `null` | no |
| <a name="input_application_failure_feedback_role_arn"></a> [application\_failure\_feedback\_role\_arn](#input\_application\_failure\_feedback\_role\_arn) | IAM role for failure feedback (application protocol). | `string` | `null` | no |
| <a name="input_http_success_feedback_role_arn"></a> [http\_success\_feedback\_role\_arn](#input\_http\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback (HTTP protocol). | `string` | `null` | no |
| <a name="input_http_success_feedback_sample_rate"></a> [http\_success\_feedback\_sample\_rate](#input\_http\_success\_feedback\_sample\_rate) | Percentage of success to sample (0-100) for HTTP protocol. | `number` | `null` | no |
| <a name="input_http_failure_feedback_role_arn"></a> [http\_failure\_feedback\_role\_arn](#input\_http\_failure\_feedback\_role\_arn) | IAM role for failure feedback (HTTP protocol). | `string` | `null` | no |
| <a name="input_lambda_success_feedback_role_arn"></a> [lambda\_success\_feedback\_role\_arn](#input\_lambda\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback (Lambda protocol). | `string` | `null` | no |
| <a name="input_lambda_success_feedback_sample_rate"></a> [lambda\_success\_feedback\_sample\_rate](#input\_lambda\_success\_feedback\_sample\_rate) | Percentage of success to sample (0-100) for Lambda protocol. | `number` | `null` | no |
| <a name="input_lambda_failure_feedback_role_arn"></a> [lambda\_failure\_feedback\_role\_arn](#input\_lambda\_failure\_feedback\_role\_arn) | IAM role for failure feedback (Lambda protocol). | `string` | `null` | no |
| <a name="input_sqs_success_feedback_role_arn"></a> [sqs\_success\_feedback\_role\_arn](#input\_sqs\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback (SQS protocol). | `string` | `null` | no |
| <a name="input_sqs_success_feedback_sample_rate"></a> [sqs\_success\_feedback\_sample\_rate](#input\_sqs\_success\_feedback\_sample\_rate) | Percentage of success to sample (0-100) for SQS protocol. | `number` | `null` | no |
| <a name="input_sqs_failure_feedback_role_arn"></a> [sqs\_failure\_feedback\_role\_arn](#input\_sqs\_failure\_feedback\_role\_arn) | IAM role for failure feedback (SQS protocol). | `string` | `null` | no |
| <a name="input_firehose_success_feedback_role_arn"></a> [firehose\_success\_feedback\_role\_arn](#input\_firehose\_success\_feedback\_role\_arn) | The IAM role permitted to receive success feedback (Firehose protocol). | `string` | `null` | no |
| <a name="input_firehose_success_feedback_sample_rate"></a> [firehose\_success\_feedback\_sample\_rate](#input\_firehose\_success\_feedback\_sample\_rate) | Percentage of success to sample (0-100) for Firehose protocol. | `number` | `null` | no |
| <a name="input_firehose_failure_feedback_role_arn"></a> [firehose\_failure\_feedback\_role\_arn](#input\_firehose\_failure\_feedback\_role\_arn) | IAM role for failure feedback (Firehose protocol). | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the SNS topic. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource (same as the ARN). |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the SNS topic. |
| <a name="output_name"></a> [name](#output\_name) | The name of the SNS topic. |
| <a name="output_owner"></a> [owner](#output\_owner) | The AWS Account ID of the SNS topic owner. |
| <a name="output_beginning_archive_time"></a> [beginning\_archive\_time](#output\_beginning\_archive\_time) | The oldest timestamp at which a FIFO topic subscriber can start a replay. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | Map of tags assigned to the resource, including those inherited from the provider. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for SNS topic encryption. |
<!-- END_TF_DOCS -->
