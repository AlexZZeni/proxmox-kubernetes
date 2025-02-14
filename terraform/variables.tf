variable "environment" {
  description = "Define the Environment"
  type = string
}

variable "common" {
  description = "A map of common variables"
  type        = map(string)
}

variable "gateways" {
  description = "A map of gateways variables"
  type        = map(any)
}

variable "masters" {
  description = "A map of masters variables"
  type        = map(map(string))
  default     = {}  # Empty map as default
}

variable "workers" {
  description = "A map of workers variables"
  type        = map(map(string))
  default     = {}  # Empty map as default
}

variable "machines" {
  description = "A map of machines variables"
  type        = map(map(string))
  default     = {}  # Empty map as default
}