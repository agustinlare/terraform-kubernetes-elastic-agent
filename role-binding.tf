resource "kubernetes_role_binding" "rb_elastic_agente" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.app
    namespace = var.namespace
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = var.app
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.app
  }
}

resource "kubernetes_role_binding" "rb_elastic_agente_kubeadm_config" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "elastic-agent-kubeadm-config"
    namespace = var.namespace
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = var.app
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "elastic-agent-kubeadm-config"
  }
}