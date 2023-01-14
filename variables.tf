variable "app" {
  type    = string
  default = "elastic-agent"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "image" {
  type    = string
  default = "docker.elastic.co/beats/elastic-agent:8.3.0"
}

variable "env" {
  type    = string
  default = ""
}

variable "fleet_url" {
  type    = string
  default = ""
}

variable "fleet_token" {
  type      = string
  default   = ""
  sensitive = true
}

variable "kibana_user" {
  type    = string
  default = "elastic"
}

variable "kibana_password" {
  type    = string
  default = "changeme"
}

variable "kibana_host" {
  type    = string
  default = "http://kibana:5601"
}

variable "fleet_enroll" {
  type    = string
  default = "1"
}

variable "fleet_insecure" {
  type    = string
  default = "true"
}

variable "enabled" {
  type    = bool
  default = false
}

variable "heartbeat" {
  type = object({
    image       = string
    req_cpu     = string
    req_mem     = string
    user        = string
    password    = string
    cloud_id    = string
    cloud_auth  = string
    config_file = any
  })
  default = null
}