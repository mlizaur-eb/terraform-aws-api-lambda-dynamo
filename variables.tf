
variable "account_id" {
  type        = string
  description = "Account id"
}

variable "function_name" {
  type        = string
  description = "Lambda Name."
}

variable "stage" {
  type        = string
  description = "TLZ Stage"
}

variable "dynamo_table" {
  type        = string
  description = "Dynamo Table Name."
}

variable "dynamo_hash_key" {
  type        = string
  description = "Dynamo Hash Key"
}

variable "dynamo_env" {
  type        = string
  description = "Dynamo Env"
}
