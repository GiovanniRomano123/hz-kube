# Tell Terraform to include the hcloud provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      # Here we use version 1.45.0, this may change in the future
      version = "1.45.0"
    }
  }
}

# Declare the hcloud_token variable from .tfvars
variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

variable "cloud_init_script" {
  sensitive = true
  type      = string
}

variable "cloud_init_worker_script" {
  sensitive = true
  type      = string
}

# Configure the Hetzner Cloud Provider with your token
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_network" "private_network" {
  name     = "kubernetes-cluster"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private_network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_server" "master-node" {
  name        = "master-node"
  image       = "ubuntu-22.04"
  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = hcloud_network.private_network.id
    # IP Used by the master node, needs to be static
    # Here the worker nodes will use 10.0.1.1 to communicate with the master node
    ip = "10.0.1.1"
  }
  user_data = var.cloud_init_script

  # If we don't specify this, Terraform will create the resources in parallel
  # We want this node to be created after the private network is created
  depends_on = [hcloud_network_subnet.private_network_subnet]
}

resource "hcloud_server" "worker-node-1" {
  name        = "worker-node-1"
  image       = "ubuntu-22.04"
  server_type = "cax11"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = hcloud_network.private_network.id
  }
  user_data = var.cloud_init_worker_script

  # add the master node as a dependency
  depends_on = [hcloud_network_subnet.private_network_subnet, hcloud_server.master-node]
}