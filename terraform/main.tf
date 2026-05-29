terraform {
  required_providers {
    virtualbox = {
      source  = "shekeriev/virtualbox"
      version = "0.0.4"
    }
  }
}

provider "virtualbox" {
  delay      = 60
  mintimeout = 5
}

resource "virtualbox_vm" "db" {
  name      = "db-vm"
  image = "./bento.box"
  cpus      = 1
  memory    = "1024 mib"
  user_data = file("${path.module}/cloud_init.cfg")

  network_adapter {
    type = "nat"
  }

  network_adapter {
    type           = "hostonly"
    host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }
}

resource "virtualbox_vm" "worker" {
  name      = "worker-vm"
  image = "./bento.box"
  cpus      = 1
  memory    = "1024 mib"
  user_data = file("${path.module}/cloud_init.cfg")

  network_adapter {
    type = "nat"
  }

  network_adapter {
    type           = "hostonly"
    host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }
}

output "db_ip" {
  value = virtualbox_vm.db.network_adapter[1].ipv4_address
}

output "worker_ip" {
  value = virtualbox_vm.worker.network_adapter[1].ipv4_address
}