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

  group "janez" {
    count = 2

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "janez" {
      driver = "docker"
      config {
        image = "docker.io/cimesi/janez"
      }

      template {
        data = <<EOH
# timestamp
        EOH
        destination = "local/file.yml"
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
        name = "janez"
        port = "http"

        tags = [
          "dns.enable=true",
          "dns.record=janez.cime.si",
          "traefik.enable=true",
          "traefik.http.routers.homepage-janez.entrypoints=http",
          "traefik.http.routers.homepage-janez.rule=Host(`janez.cime.si`)",
          "traefik.http.routers.homepage-janez.middlewares=homepage-janez",
          "traefik.http.middlewares.homepage-janez.redirectscheme.scheme=https",
          "traefik.http.routers.homepage-janez-https.entrypoints=https",
          "traefik.http.routers.homepage-janez-https.rule=Host(`janez.cime.si`)",
          "traefik.http.routers.homepage-janez-https.tls.certresolver=le-cime",
          "traefik.http.routers.homepage-janez-https.tls.domains[0].main=janez.cime.si",
          "traefik.http.routers.homepage-janez-https.middlewares=homepage-janez-https-404page",
          "traefik.http.middlewares.homepage-janez-https-404page.errors.status=404",
          "traefik.http.middlewares.homepage-janez-https-404page.errors.service=janez",
          "traefik.http.middlewares.homepage-janez-https-404page.errors.query=/404.html",
          # Redirect old page to new one
          "traefik.http.routers.homepage-janez2.entrypoints=http",
          "traefik.http.routers.homepage-janez2.rule=Host(`janez2.cime.si`)",
          "traefik.http.routers.homepage-janez2.middlewares=homepage-janez2",
          "traefik.http.middlewares.homepage-janez2.redirectregex.regex=^http://janez2.cime.si/(.*)",
          "traefik.http.middlewares.homepage-janez2.redirectregex.replacement=http://janez.cime.si",
          "traefik.http.routers.homepage-janez2-https.entrypoints=https",
          "traefik.http.routers.homepage-janez2-https.rule=Host(`janez2.cime.si`)",
          "traefik.http.routers.homepage-janez2-https.tls.certresolver=le-cime",
          "traefik.http.routers.homepage-janez2-https.tls.domains[0].main=janez2.cime.si",
          "traefik.http.routers.homepage-janez2-https.middlewares=homepage-janez2-https",
          "traefik.http.middlewares.homepage-janez2-https.redirectregex.regex=^https://janez2.cime.si/(.*)",
          "traefik.http.middlewares.homepage-janez2-https.redirectregex.replacement=https://janez.cime.si"
          
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
