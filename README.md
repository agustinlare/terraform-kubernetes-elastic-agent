# terraform-kubernetes-module-es-agent

# Example
module "module_es_agent" {
  source  = "app.terraform.io/clave/module-es-agent/kubernetes"
  version = "0.2.0"

  enabled = true

  fleet_url   = var.FLEET_URL
  fleet_token = var.FLEET_TOKEN
  env         = var.environment

  heartbeat = {
    image       = "elastic/heartbeat:8.4.0"
    req_cpu     = "500m"
    req_mem     = "1536Mi"
    user        = var.HEARTBEAT_USER
    password    = var.HEARTBEAT_PASSWORD
    cloud_id    = var.HEARTBEAT_CLOUD_ID
    cloud_auth  = "${var.HEARTBEAT_USER}:${var.HEARTBEAT_PASSWORD}"
    config_file = "${file("./manifests/cm_heartbeat.yml")}"
  }

  depends_on = [
    module.eks
  ]
}

## Provider

terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.4"
    }
  }
  required_version = "1.0.11"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "clave-prod"]
  }
  load_config_file = false
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Enables the deployment of elastic agent | bool | false | false |
| fleet_url | Integration agente fleet URL | string | "" | false |
| fleet_token | Integration agente fleet token | string | "" | false |
| kibana_user | Kibana login user | string | elastic | false |
| kibana_password | Kibana login user | string | changeme | false |
| Enviroment | String corresponding to the name of the enviroment e.g. prod - qa - dev | string | "" | false |
| hearbeat | Map that enables de deployment of heartbeat | object | null | true |
| .image | Image to be pulled by the deployment | string | null | false |
| .req_cpu | Set the requested CPU for the deployment | string | null | false |
| .req_mem | Set the requested Memory for the deployment | string | null | false |
| .user | User has to have permissions to inject documents | string | null | true |
| .password | Password required for the user in the value before | string | null | true |
| .cloud_id | This value is obteined from the integration console of ElasticSearch | string | null | true |
| .cloud_auth | It's given in the following format $hearbeat.user:$hearbeat.password e.g. elastic:changeme | string | null | true |
| .config_file | Content of the config file | string | null | true |