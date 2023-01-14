resource "kubernetes_cluster_role_binding" "crb_elastic_agente" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.app
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = var.app
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.app
  }
}