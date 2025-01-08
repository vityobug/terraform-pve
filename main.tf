terraform {
  required_version = ">= 1.10.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0" # Use the appropriate version constraint
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.3"
    }
  }
}

provider "proxmox" {
  endpoint = var.PVE_URL
  username = var.PVE_USERNAME
  password = var.PVE_PASSWORD
  insecure = true # Set to false if the cert is publicly signed.
  ssh {
    agent = true # Using SSH for authention.
  }
}

