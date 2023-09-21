variable "version" {
  default = ""
}

variable "repo" {
  default = "chinayin/v2ray"
}

group "default" {
  targets = ["debian"]
}

function "platforms" {
  params = []
  result = ["linux/amd64", "linux/arm64"]
}

variable "registry" {
  default = "docker.io"
}

variable "repository" {
  default = "${registry}/${repo}"
}

target "_all_platforms" {
  platforms = platforms()
}

target "debian" {
  inherits = ["_all_platforms"]
  context  = "debian"
  tags     = [
    "${repository}:latest",
    "${repository}:bookworm",
    "${repository}:${version}",
  ]
}
