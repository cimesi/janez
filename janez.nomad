job "janez" {
  region = "global"
  datacenters = ["zalog"]
  type = "service"

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  group "janez2" {
    count = 2

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "janez2" {
      driver = "docker"
      config {
        image = "docker.io/cimesi/janez"
      }

      config {
        port_map = {
          http = 80
        }
      }

      resources {
        cpu    = 20
        memory = 64

        network {
          port "http" {}
        }
      }

      service {
        name = "janez2"
        port = "http"

        tags = [
          "dns.enable=true",
          "dns.record=janez2.cime.si",
          "traefik.enable=true",
          "traefik.http.routers.homepage-janez2.entrypoints=http",
          "traefik.http.routers.homepage-janez2.rule=Host(`janez2.cime.si`)",
          "traefik.http.routers.homepage-janez2.middlewares=homepage-janez2",
          "traefik.http.middlewares.homepage-janez2.redirectscheme.scheme=https",
          "traefik.http.routers.homepage-janez2-https.entrypoints=https",
          "traefik.http.routers.homepage-janez2-https.rule=Host(`janez2.cime.si`)",
          "traefik.http.routers.homepage-janez2-https.tls.certresolver=le-cime",
          "traefik.http.routers.homepage-janez2-https.tls.domains[0].main=janez2.cime.si",
        ]

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/"
        }
      }
    }
  }
}
