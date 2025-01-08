# Proxmox Kubernetes Cluster Setup

This repository contains Terraform code to provision a Kubernetes cluster on a Proxmox Virtual Environment (PVE). The setup includes one master node and three worker nodes, each configured with Ubuntu Cloud Images. I personally use this to quickly setup a k8s cluster, but the deployment is not limited to that.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Resources](#resources)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

This Terraform configuration automates the creation of virtual machines (VMs) on a Proxmox server to set up a Kubernetes cluster. The cluster consists of:
- **1 Master Node**: Named `k8s-master-211`.
- **3 Worker Nodes**: Named `k8s-worker-221`, `k8s-worker-222`, and `k8s-worker-223`.

Each VM is provisioned with:
- 4 CPU cores
- 8 GB of RAM
- 50 GB of SSD storage
- Ubuntu Cloud Image as the base OS
- Pre-configured SSH keys for authentication

**Note**: The VM names end with an ID that matches the last octet of the subnet IP address for ease of identification. For example:
- `k8s-master-211` has the IP `172.31.31.211`.
- `k8s-worker-221` has the IP `172.31.31.221`.

---

## Prerequisites

Before using this Terraform configuration, ensure you have the following:

1. **Proxmox Server**: Access to a Proxmox Virtual Environment (PVE) with at least one node.
2. **Terraform**: Install Terraform on your local machine. Download it from [here](https://www.terraform.io/downloads.html).
3. **SSH Key**: A public SSH key (`id_rsa.pub`) placed in the `./files/` directory. This key will be used for VM authentication.
4. **Proxmox Provider**: Ensure the `bpg/proxmox` provider is available in your Terraform configuration.

---

## Usage

### 1. Clone the Repository
```bash
git clone https://github.com/vityobug/terraform-pve-k8s.git
cd terraform-pve
```

### 2. Set Environment Variables
Set the following environment variables to authenticate with your Proxmox server:
```bash
export TF_VAR_PVE_URL="https://your-proxmox-server:8006"
export TF_VAR_PVE_USERNAME="your-username"
export TF_VAR_PVE_PASSWORD="your-password"
```

3. Initialize Terraform
Run the following command to initialize Terraform and download the required providers:
```bash
terraform init
```

4. Review the Configuration
Modify the following variables in the resources.tf file as needed:

`datastore_id`: The name of your Proxmox datastore (e.g., truenas or local-zfs).
`node_name`: The name of your Proxmox node (e.g., pve).
`username`: The username for the VM user account.
`ip_config`: Update the IP addresses and gateway if necessary.

5. Apply the Configuration
Run the following command to create the VMs:
```bash
terraform apply
```
Terraform will display a plan of the resources to be created. Confirm by typing `yes`.

6. Destroy the Resources
To tear down the cluster and delete the VMs, run:
```bash
terraform destroy
```

Configuration
Variables
The following variables are defined in variables.tf:
`PVE_URL`: The full URL to the Proxmox cluster (e.g., https://your-proxmox-server:8006).
`PVE_USERNAME`: The username for authenticating with the Proxmox cluster.
`PVE_PASSWORD`: The password for authenticating with the Proxmox cluster.

These variables are sensitive and should be set using environment variables.
**Resources**
The following resources are created:

`proxmox_virtual_environment_download_file`: Downloads the Ubuntu Cloud Image.
`proxmox_virtual_environment_vm`: Creates the master and worker VMs.

---

## Environment Variables
To authenticate with your Proxmox server, set the following environment variables before running Terraform:
```bash
export TF_VAR_PVE_URL="https://your-proxmox-server:8006"
export TF_VAR_PVE_USERNAME="your-username"
export TF_VAR_PVE_PASSWORD="your-password"
```

---

## Resources

### Master Node
* Name: `k8s-master-211`
* IP Address: `172.31.31.211`
* CPU: `4 cores`
* RAM: `8 GB`
* Disk: `50 GB SSD`

### Worker Nodes
* Names: `k8s-worker-221, k8s-worker-222, k8s-worker-223`
* IP Addresses: `172.31.31.221, 172.31.31.222, 172.31.31.223`
* CPU: `4 cores each`
* RAM: `8 GB each`
* Disk: `50 GB SSD each`

**Note**: The VM names end with an ID that matches the last octet of the subnet IP address for ease of identification. For example:
* `k8s-master-211` has the IP `172.31.31.211`.
* `k8s-worker-221` has the IP `172.31.31.221`.

---

## Outputs
After applying the Terraform configuration, the following outputs are available:

* **SSH Public Key:** The content of the SSH public key used for authentication.
* **VM IPs:** The IP addresses of the master and worker nodes.

To view the outputs, run:
```bash
terraform output
```

---

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request.

---

## License
This project is licensed under the GPL-3.0 License. See the LICENSE file for details.
