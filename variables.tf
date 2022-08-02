variable "pulsar_version" {
    description = "Pulsar version"
}
variable "ssh_user" {
    description = "ssh user to gce instance"
}
variable "ssh_key_file" {
    description = "ssh key to gce instance"
}
variable "project" {
    description = "google project id"
}
variable "region" {
    description = "google region"
}
variable "zone" {
    description = "google zone"
}
variable "terraform_sa_credentials" {
    description = "terraform sa"
}
variable "terraform_runner"{
    description = "impersonated sa"
}
variable "gce_image" {
    description = "debian or ubuntu. debian-cloud/debian-11"
}
variable "num_zookeeper_nodes" {
  description = "The number of GCE instances running ZooKeeper"
}
variable "num_bookie_nodes" {
  description = "The number of GCE instances running BookKeeper"
}
variable "num_broker_nodes" {
  description = "The number of GCE instances running Pulsar brokers"
}
variable "num_proxy_nodes" {
  description = "The number of GCE instances running Pulsar proxies"
}
variable "num_client_nodes" {
  description = "The number of GCE instances running Pulsar proxies"
}
variable "instance_types" {
  type = map(string)
}
variable "disk_sizes" {
  type = map(number)
}