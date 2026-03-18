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

variable "logical_product_family" {
  description = "Logical product family for resource naming."
  type        = string
}

variable "logical_product_service" {
  description = "Logical product service for resource naming."
  type        = string
}

variable "class_env" {
  description = "Class environment for resource naming (e.g., dev, prod)."
  type        = string
}

variable "instance_env" {
  description = "Instance environment for resource naming."
  type        = number
}

variable "instance_resource" {
  description = "Instance resource for resource naming."
  type        = number
}

variable "resource_names_map" {
  description = "Map of resource types to naming configuration."
  type = map(object({
    name       = string
    max_length = number
  }))
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Set to null when using name."
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name for the SNS topic."
  type        = string
  default     = null
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON for the SNS topic."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The SNS delivery policy."
  type        = string
  default     = null
}

variable "signature_version" {
  description = "The signature version for the topic (1 for SHA1 or 2 for SHA256)."
  type        = string
  default     = null
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active."
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO topic."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics."
  type        = bool
  default     = null
}

variable "archive_policy" {
  description = "The message archive policy for FIFO topics."
  type        = string
  default     = null
}

variable "fifo_throughput_scope" {
  description = "Enables higher throughput for FIFO topics. Valid values: Topic, MessageGroup."
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback (application protocol)."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for application protocol."
  type        = number
  default     = null
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (application protocol)."
  type        = string
  default     = null
}

variable "http_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback (HTTP protocol)."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for HTTP protocol."
  type        = number
  default     = null
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (HTTP protocol)."
  type        = string
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback (Lambda protocol)."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for Lambda protocol."
  type        = number
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (Lambda protocol)."
  type        = string
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback (SQS protocol)."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for SQS protocol."
  type        = number
  default     = null
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (SQS protocol)."
  type        = string
  default     = null
}

variable "firehose_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback (Firehose protocol)."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for Firehose protocol."
  type        = number
  default     = null
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (Firehose protocol)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the SNS topic."
  type        = map(string)
  default     = {}
}
