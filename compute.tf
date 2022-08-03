resource "google_compute_instance" "zk" {
    count = var.num_zookeeper_nodes
    name = "zookeeper-${count.index+1}"
    machine_type = var.instance_types["zookeeper"]
    metadata = {
      "ssh-keys" = "${var.ssh_user}:${file(var.ssh_key_file)}"
    }

    hostname = "zookeeper-${count.index+1}.${trimsuffix(google_dns_managed_zone.sn-se-zone.dns_name, ".")}"
    boot_disk {
        initialize_params {
            image = var.gce_image
        }
    }
    network_interface {
      network = google_compute_network.se_network.name
      access_config {
        
      }
    }
    lifecycle {
      ignore_changes = [attached_disk]
    }
    tags = ["pulsar", "zookeeper"]
}

resource "google_dns_record_set" "zk-dns" {
    count = var.num_zookeeper_nodes
    managed_zone = google_dns_managed_zone.sn-se-zone.name
    name = "zookeeper-${count.index+1}.${google_dns_managed_zone.sn-se-zone.dns_name}"
    type = "A"
    rrdatas = [google_compute_instance.zk[count.index].network_interface.0.network_ip]
    ttl = 300
}

resource "google_compute_instance" "bookie" {
    count = var.num_bookie_nodes
    name = "bookie-${count.index+1}"
    machine_type = var.instance_types["bookie"]
    metadata = {
      "ssh-keys" = "${var.ssh_user}:${file(var.ssh_key_file)}"
    }
    hostname = "bookie-${count.index+1}.${trimsuffix(google_dns_managed_zone.sn-se-zone.dns_name, ".")}"
    boot_disk {
        initialize_params {
            image = var.gce_image
        }
    }
    network_interface {
      network = google_compute_network.se_network.name
      access_config {
        
      }
    }  
    lifecycle {
      ignore_changes = [attached_disk]
    }
    tags = ["pulsar", "bookkeeper", "bookie"]
}

resource "google_dns_record_set" "bk-dns" {
    count = var.num_bookie_nodes
    managed_zone = google_dns_managed_zone.sn-se-zone.name
    name = "bookkeeper-${count.index+1}.${google_dns_managed_zone.sn-se-zone.dns_name}"
    type = "A"
    rrdatas = [google_compute_instance.bookie[count.index].network_interface.0.network_ip]
    ttl = 300
}

resource "google_compute_instance" "broker" {
    count = var.num_broker_nodes
    name = "broker-${count.index+1}"
    machine_type = var.instance_types["broker"]
    metadata = {
      "ssh-keys" = "${var.ssh_user}:${file(var.ssh_key_file)}"
    }
    hostname = "broker-${count.index+1}.${trimsuffix(google_dns_managed_zone.sn-se-zone.dns_name, ".")}"
    boot_disk {
        initialize_params {
            image = var.gce_image
        }
    }
    network_interface {
      network = google_compute_network.se_network.name
      access_config {
        
      }
    } 
    lifecycle {
      ignore_changes = [attached_disk]
    }
    tags = ["pulsar", "broker"]
}

resource "google_dns_record_set" "br-dns" {
    count = var.num_broker_nodes
    managed_zone = google_dns_managed_zone.sn-se-zone.name
    name = "broker-${count.index+1}.${google_dns_managed_zone.sn-se-zone.dns_name}"
    type = "A"
    rrdatas = [google_compute_instance.broker[count.index].network_interface.0.network_ip]
    ttl = 300
}

resource "google_compute_instance" "client" {
    count = var.num_client_nodes
    name = "client-${count.index+1}"
    machine_type = var.instance_types["client"]
    metadata = {
      "ssh-keys" = "${var.ssh_user}:${file(var.ssh_key_file)}"
    }
    hostname = "client-${count.index+1}.${trimsuffix(google_dns_managed_zone.sn-se-zone.dns_name, ".")}"
    boot_disk {
        initialize_params {
            image = var.gce_image
        }
    }
    network_interface {
      network = google_compute_network.se_network.name
      access_config {
        
      }
    } 
    lifecycle {
      ignore_changes = [attached_disk]
    }
    tags = ["pulsar", "client"]
}

resource "google_dns_record_set" "cli-dns" {
    count = var.num_client_nodes
    managed_zone = google_dns_managed_zone.sn-se-zone.name
    name = "client-${count.index+1}.${google_dns_managed_zone.sn-se-zone.dns_name}"
    type = "A"
    rrdatas = [google_compute_instance.client[count.index].network_interface.0.network_ip]
    ttl = 300
}

resource "google_compute_instance" "proxy" {
    count = var.num_proxy_nodes
    name = "proxy-${count.index+1}"
    machine_type = var.instance_types["proxy"]
    metadata = {
      "ssh-keys" = "${var.ssh_user}:${file(var.ssh_key_file)}"
    }
    hostname = "proxy-${count.index+1}.${trimsuffix(google_dns_managed_zone.sn-se-zone.dns_name, ".")}"
    boot_disk {
        initialize_params {
            image = var.gce_image
        }
    }
    network_interface {
      network = google_compute_network.se_network.name
      access_config {
      }
    } 
    lifecycle {
      ignore_changes = [attached_disk]
    }
    tags = ["pulsar", "proxy"]
}

resource "google_dns_record_set" "px-dns" {
    count = var.num_proxy_nodes
    managed_zone = google_dns_managed_zone.sn-se-zone.name
    name = "proxy-${count.index+1}.${google_dns_managed_zone.sn-se-zone.dns_name}"
    type = "A"
    rrdatas = [google_compute_instance.proxy[count.index].network_interface.0.network_ip]
    ttl = 300
}

resource "google_compute_disk" "bookie_journal_disks" {
  count = var.num_bookie_nodes
  name = "journal-${count.index+1}"
  type = "pd-ssd"
  size = var.disk_sizes["journal"]
}

resource "google_compute_disk" "bookie_ledger_disks" {
  count = var.num_bookie_nodes
  name = "ledger-${count.index+1}"
  type = "pd-ssd"
  size = var.disk_sizes["ledger"]
}

resource "google_compute_disk" "zk_data_disks" {
  count = var.num_zookeeper_nodes
  name = "zk-${count.index+1}"
  type = "pd-ssd"
  size = var.disk_sizes["zk_data"]
}

resource "google_compute_attached_disk" "zk_attached_disk" {
    count = var.num_zookeeper_nodes
    disk = google_compute_disk.zk_data_disks[count.index].id
    instance = google_compute_instance.zk[count.index].id
}

resource "google_compute_attached_disk" "journal_attached_disk" {
    count = var.num_bookie_nodes
    disk = google_compute_disk.bookie_journal_disks[count.index].id
    instance = google_compute_instance.bookie[count.index].id
}

resource "google_compute_attached_disk" "ledger_attached_disk" {
    count = var.num_bookie_nodes
    disk = google_compute_disk.bookie_ledger_disks[count.index].id
    instance = google_compute_instance.bookie[count.index].id
}


resource "local_file" "ansible_host" {
  content = templatefile("templates/hosts.tpl",
    {
        zookeepers = google_compute_instance.zk.*.network_interface.0.access_config.0.nat_ip
        bookies = google_compute_instance.bookie.*.network_interface.0.access_config.0.nat_ip
        brokers = google_compute_instance.broker.*.network_interface.0.access_config.0.nat_ip
        proxy = google_compute_instance.proxy.*.network_interface.0.access_config.0.nat_ip
        client = google_compute_instance.client.*.network_interface.0.access_config.0.nat_ip
    }
  )
  filename = "${path.module}/hosts"

}

resource "null_resource" "ansible_playbook_os" {
    depends_on = [
      local_file.ansible_host
    ]
    provisioner "local-exec" {
        command = "ansible-playbook os/main.yaml --extra-vars=\"pulsar_version=$pulsar_version\""
        environment = {
          pulsar_version = var.pulsar_version
         }
    }
}

resource "null_resource" "ansible_playbook_pulsar" {
    depends_on = [
      local_file.ansible_host,
      null_resource.ansible_playbook_os,
    ]
    provisioner "local-exec" {
        command = "ansible-playbook pulsar/main.yaml --extra-vars=\"pulsar_version=$pulsar_version pulsar_cluster_name=$pulsar_cluster_name\""
        environment = {
          pulsar_version = var.pulsar_version
          pulsar_cluster_name = var.pulsar_cluster_name
         }
    }
}
