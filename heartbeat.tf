locals {
  name = "heartbeat"
  ns   = "kube-system"
}

resource "kubernetes_config_map" "heartbeat" {
  metadata {
    name      = "heartbeat-deployment-config"
    namespace = local.ns
  }

  data = {
    "heartbeat.yml" = var.heartbeat["config_file"]
  }
}

resource "kubernetes_deployment" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = local.name
    namespace = local.ns

    labels = {
      k8s-app = local.name
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = local.name
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = local.name
        }
      }

      spec {
        service_account_name = local.name
        host_network         = true
        dns_policy           = "ClusterFirstWithHostNet"

        container {
          image = var.heartbeat["image"]
          name  = local.name
          args = [
            "-c", "/etc/heartbeat.yml",
            "-e",
          ]

          resources {
            limits {
              memory = "1536Mi"
            }
            requests {
              cpu    = var.heartbeat["req_cpu"]
              memory = var.heartbeat["req_mem"]
            }
          }

          security_context {
            run_as_user = 0
          }

          env {
            name  = "ELASTICSEARCH_HOST"
            value = "elasticsearch"
          }
          env {
            name  = "ELASTICSEARCH_PORT"
            value = "9200"
          }
          env {
            name  = "ELASTICSEARCH_USERNAME"
            value = var.heartbeat["user"]
          }
          env {
            name  = "ELASTICSEARCH_PASSWORD"
            value = var.heartbeat["password"]
          }
          env {
            name  = "ELASTIC_CLOUD_ID"
            value = var.heartbeat["cloud_id"]
          }
          env {
            name  = "ELASTIC_CLOUD_AUTH"
            value = var.heartbeat["cloud_auth"]
          }
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          volume_mount {
            name       = "config"
            mount_path = "/etc/heartbeat.yml"
            read_only  = true
            sub_path   = "heartbeat.yml"
          }

          volume_mount {
            name       = "data"
            mount_path = "/usr/share/heartbeat/data"
          }
        }

        volume {
          name = "config"
          config_map {
            default_mode = "0600"
            name         = "heartbeat-deployment-config"
          }
        }

        volume {
          name = "data"
          host_path {
            path = "/var/lib/heartbeat-data"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}

resource "kubernetes_cluster_role_binding" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name = local.name
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = var.app
    namespace = local.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.name
  }
}

resource "kubernetes_role_binding" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = local.name
    namespace = local.ns
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = local.name
    namespace = local.ns
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = local.name
  }
}

resource "kubernetes_role_binding" "heartbeat-kubeadm-config" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = "heartbeat-kubeadm-config"
    namespace = local.ns
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = local.name
    namespace = local.ns
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "heartbeat-kubeadm-config"
  }
}

resource "kubernetes_cluster_role" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name = local.name
    labels = {
      k8s-app = local.name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "nodes", "services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch"]
  }

}

resource "kubernetes_role" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = local.name
    namespace = local.ns
    labels = {
      k8s-app = local.name
    }
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "update", "get"]
  }
}

resource "kubernetes_role" "heartbeat-kubeadm-config" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = "heartbeat-kubeadm-config"
    namespace = local.ns
    labels = {
      k8s-app = local.name
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["kubeadm-config"]
    verbs          = ["get"]
  }
}

resource "kubernetes_service_account" "heartbeat" {
  count = var.heartbeat != null && var.enabled ? 1 : 0

  metadata {
    name      = local.name
    namespace = local.ns
    labels = {
      k8s-app = local.name
    }
  }
}