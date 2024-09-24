variable "cloud_provider" {
    description = "Cloud Provider Name"
    type = string
}

variable "region" {
    description = "Cloud Provider Region Name"
    type = string
}

variable "cluster_cider" {
    description = "Cluster CIDR Block"
    type = string
}

variable "vault_cluster_id" {
    description = "Cluster Name"
    type = string
}

variable "vault_hvn" {
    description = "HCP HVN ID"
    type = string
}

variable "tier_type" {
    description = "Vault Cluster Tier Type"
    type = string
}