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

variable "name" {
  description = "The name of the SNS topic. Topic names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long. For a FIFO topic, the name must end with the .fifo suffix. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
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
  description = "The SNS delivery policy. More details in the AWS documentation."
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. For more information, see Key Terms in AWS SNS documentation."
  type        = string
  default     = null
}

variable "signature_version" {
  description = "The signature version for the topic (1 for SHA1 or 2 for SHA256)."
  type        = string
  default     = null

  validation {
    condition     = var.signature_version == null ? true : contains(["1", "2"], var.signature_version)
    error_message = "Signature version must be 1 or 2."
  }
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active."
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null ? true : contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "Tracing config must be PassThrough or Active."
  }
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic."
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

  validation {
    condition     = var.fifo_throughput_scope == null ? true : contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "FIFO throughput scope must be Topic or MessageGroup."
  }
}

# Application feedback
variable "application_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic (application protocol)."
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for application protocol."
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null ? true : (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (application protocol)."
  type        = string
  default     = null
}

# HTTP feedback
variable "http_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic (HTTP protocol)."
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for HTTP protocol."
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null ? true : (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (HTTP protocol)."
  type        = string
  default     = null
}

# Lambda feedback
variable "lambda_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic (Lambda protocol)."
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for Lambda protocol."
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null ? true : (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (Lambda protocol)."
  type        = string
  default     = null
}

# SQS feedback
variable "sqs_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic (SQS protocol)."
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for SQS protocol."
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null ? true : (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "Sample rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role for failure feedback (SQS protocol)."
  type        = string
  default     = null
}

# Firehose feedback
variable "firehose_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic (Firehose protocol)."
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage of success to sample (0-100) for Firehose protocol."
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null ? true : (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "Sample rate must be between 0 and 100."
  }
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
