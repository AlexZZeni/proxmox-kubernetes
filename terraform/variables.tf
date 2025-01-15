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
}

variable "workers" {
  description = "A map of workers variables"
  type        = map(map(string))
}
