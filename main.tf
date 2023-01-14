resource "kubernetes_daemonset" "daemonset" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.app
    namespace = var.namespace
    labels = {
      app = var.app
    }
  }

  spec {
    selector {
      match_labels = {
        app = var.app
      }
    }

    template {
      metadata {
        labels = {
          app = var.app
        }
      }

      spec {
        service_account_name            = var.app
        automount_service_account_token = true
        host_network                    = true
        dns_policy                      = "ClusterFirstWithHostNet"

        container {
          image = var.image
          name  = var.app

          resources {
            limits {
              memory = "512Mi"
            }
            requests {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          security_context {
            run_as_user = 0
          }

          env {
            name  = "FLEET_ENROLL"
            value = var.fleet_enroll
          }
          env {
            name  = "FLEET_INSECURE"
            value = var.fleet_insecure
          }
          env {
            name  = "FLEET_URL"
            value = var.fleet_url
          }
          env {
            name  = "FLEET_ENROLLMENT_TOKEN"
            value = var.fleet_token
          }
          env {
            name  = "KIBANA_HOST"
            value = var.kibana_host
          }
          env {
            name  = "KIBANA_FLEET_USERNAME"
            value = var.kibana_user
          }
          env {
            name  = "KIBANA_FLEET_PASSWORD"
            value = var.kibana_password
          }
          env {
            name  = "ELASTIC_AGENT_TAGS"
            value = var.env
          }
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name  = "ELASTIC_AGENT_TAGS"
            value = var.env
          }
          volume_mount {
            name       = "proc"
            mount_path = "/hostfs/proc"
            read_only  = true
          }
          volume_mount {
            name       = "cgroup"
            mount_path = "/hostfs/sys/fs/cgroup"
            read_only  = true
          }
          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
            read_only  = true
          }
        }

        volume {
          name = "proc"
          host_path {
            path = "/proc"
          }
        }
        volume {
          name = "cgroup"
          host_path {
            path = "/sys/fs/cgroup"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
      }
    }
  }
}
