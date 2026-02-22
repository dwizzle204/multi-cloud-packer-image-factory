variable "image_name" {
  type        = string
  description = "Base image name (logical)."
}

variable "image_version" {
  type        = string
  description = "Image version string (e.g., YYYY.MM.DD.build)."
}

variable "channel" {
  type        = string
  description = "Lifecycle channel: candidate|prod"
  default     = "candidate"
}

variable "git_sha" {
  type        = string
  description = "Git commit SHA for traceability."
  default     = "unknown"
}

variable "build_date" {
  type        = string
  description = "Build date for traceability."
  default     = "unknown"
}
