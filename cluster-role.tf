resource "kubernetes_cluster_role" "cr_elastic_agent" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.app
    labels = {
      k8s-app = var.app
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "nodes", "events", "services", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["replicasets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets", "deployments", "replicasets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes/stats"]
    verbs      = ["get"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}