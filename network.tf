data "http" "myip" {
    url="http://ipv4.icanhazip.com"
    request_headers = {
        Accept = "application/json"
    }
}

resource "google_compute_network" "se_network" {
    name = "se-perf"
}

resource "google_compute_firewall" "se_allow_internal" {
    name = "se-allow-internal"
    network = google_compute_network.se_network.name
    allow {
      protocol = "tcp"
    }
    allow {
      protocol = "udp"
    }
    allow {
        protocol = "icmp"
    }
    source_tags = ["pulsar"]
}

resource "google_compute_firewall" "se_allow_external" {
    name = "se-allow-external"
    network = google_compute_network.se_network.name
    allow {
      protocol = "icmp"
    }
    allow {
      protocol = "tcp"
      ports = [22, 443, 8080, 6650]
    }
    source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "google_dns_managed_zone" "sn-se-zone" {
    name = "sn-se-zone"
    dns_name = "se.sncloud.lab."
    visibility = "private"
    private_visibility_config {
      networks {
          network_url = google_compute_network.se_network.id
      }
    }
}

