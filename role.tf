resource "kubernetes_role" "r_elastic_agent" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.app
    namespace = var.namespace
    labels = {
      k8s-app = var.app
    }
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "update", "get"]
  }
}

resource "kubernetes_role" "r_elastic_agent_kubeadm_config" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = "elastic-agent-kubeadm-config"
    namespace = var.namespace
    labels = {
      k8s-app = "${var.app}"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["kubeadm-config"]
    verbs          = ["get"]
  }
}