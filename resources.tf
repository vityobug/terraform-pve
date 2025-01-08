data "local_file" "ssh_public_key" {
  filename = "./files/id_rsa.pub" # This is your public SSH key used for authentication.
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "truenas" # Change this to your datastore name.
  node_name    = "pve"     # Find and replace to match your PVE node name.

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img" # Link to the ubuntu cloudinit img.
}

resource "proxmox_virtual_environment_vm" "master_vm" {
  count           = 1
  name            = "k8s-master-21${count.index + 1}"
  node_name       = "pve"
  vm_id           = "21${count.index + 1}"
  stop_on_destroy = true

  cpu {
    cores = 4
    type  = "max"
  }

  memory {
    dedicated = 8192
    floating  = 0
  }

  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 50
    ssd          = true
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }

  initialization {

    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "172.31.31.21${count.index + 1}/24"
        gateway = "172.31.31.1"
      }
    }

    user_account {
      username = "anon" # Change this tou a desired user account that will be used for authentication.
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_vm" "worker_vm" {
  count           = 3
  name            = "k8s-worker-22${count.index + 1}"
  node_name       = "pve"
  vm_id           = "22${count.index + 1}"
  stop_on_destroy = true

  cpu {
    cores = 4
    type  = "max"
  }

  memory {
    dedicated = 8192
    floating  = 0
  }

  disk {
    datastore_id = "local-zfs"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 50
    ssd          = true
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off

  initialization {

    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "172.31.31.22${count.index + 1}/24"
        gateway = "172.31.31.1"
      }
    }

    user_account {
      username = "anon"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
