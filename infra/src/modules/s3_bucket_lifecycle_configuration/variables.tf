variable "bucket_id" {
    type = string
}

variable "lifecycle_rules" {
  type = list(object({
    id = string
    status = string
    expiration = object({
      days = number
    })
  }))
}