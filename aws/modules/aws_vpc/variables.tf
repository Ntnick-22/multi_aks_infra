variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
