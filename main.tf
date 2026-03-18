// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

check "name_or_name_prefix" {
  assert {
    condition     = (var.name != null && var.name_prefix == null) || (var.name == null && var.name_prefix != null)
    error_message = "Exactly one of name or name_prefix must be set."
  }
}

resource "aws_sns_topic" "topic" {
  name        = var.name
  name_prefix = var.name_prefix

  display_name    = var.display_name
  policy          = var.policy
  delivery_policy = var.delivery_policy

  kms_master_key_id = var.kms_master_key_id
  signature_version = var.signature_version
  tracing_config    = var.tracing_config

  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  archive_policy              = var.archive_policy
  fifo_throughput_scope       = var.fifo_throughput_scope

  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn

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
