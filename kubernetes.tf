###### root/kubernetes.tf ######

# -----------------------------------------------------------------------------
# Demo application deployed into the EKS cluster: a 2-replica nginx
# Deployment exposed through an AWS Classic Load Balancer created by the
# `LoadBalancer` Service. `depends_on = [module.eks]` waits for the node
# group to be active before workloads are created, so the load balancer
# never targets a cluster without nodes.
# -----------------------------------------------------------------------------

resource "kubernetes_deployment" "project102" {
  metadata {
    name = "terraform-project102"
    labels = {
      app = "project102"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "project102"
      }
    }

    template {
      metadata {
        labels = {
          app = "project102"
        }
      }

      spec {
        container {
          name  = "project102"
          image = "nginx:1.28-alpine"

          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }
      }
    }
  }

  depends_on = [module.eks]
}

resource "kubernetes_service" "project102" {
  metadata {
    name = "terraform-project102"
    labels = {
      app = "project102"
    }
  }

  spec {
    selector = {
      app = "project102"
    }

    # No node_port here: for a `LoadBalancer` Service the node port is
    # allocated automatically and the explicit value is ignored anyway.
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = [module.eks]
}
