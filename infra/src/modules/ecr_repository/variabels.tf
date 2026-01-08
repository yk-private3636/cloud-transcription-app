variable "name" {
    type = string
}

variable "image_tag_mutability" {
    type    = string
    validation {
      condition =  contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
      error_message = "image_tag_mutability must be one of: MUTABLE, IMMUTABLE."
    }
}

variable "scan_on_push" {
    type    = bool
    default = true
}

variable "force_delete" {
    type = bool
    default = false
}