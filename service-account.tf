resource "kubernetes_service_account" "sa_elastic_agente" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.app
    namespace = var.namespace
    labels = {
      k8s-app = "${var.app}"
    }
  }
}