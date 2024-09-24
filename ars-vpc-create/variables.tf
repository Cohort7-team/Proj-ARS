variable "ars_public_cidr_block" {
    description = "cidr block"
    default = ["10.10.10.0/24","10.10.20.0/24","10.10.30.0/24"]
}

variable "ars_private_cidr_block" {
    description = "cidr block"
    default = ["10.10.40.0/24","10.10.50.0/24","10.10.60.0/24"]
}

variable "ars_db_cidr_block" {
    description = "cidr block"
    default = ["10.10.70.0/24","10.10.80.0/24","10.10.90.0/24"]
}