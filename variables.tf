variable "project_name" {
  description = "Short lowercase name used in resource names (letters and digits only)."
  type        = string
  default     = "practicaiac"

  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.project_name))
    error_message = "project_name must be 3-12 lowercase letters or digits."
  }
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}
