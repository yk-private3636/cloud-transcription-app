variable "name" {
    type = string
}

variable "role_arn" {
    type = string
}

variable "image_uri" {
    type = string
}

variable "memory_size" {
    type = number
}

variable "timeout" {
    type = number
}

variable "architectures" {
    type = list(string)
}

variable "environment" {
    type = object({
        variables = map(string)
    })
}

