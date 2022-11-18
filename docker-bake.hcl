variable "version" {
  default = ""
}

variable "repo" {
  default = "chinayin/v2ray"
}

group "default" {
  targets = ["bullseye"]
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

target "bullseye" {
  inherits = ["_all_platforms"]
  context  = "bullseye"
  tags     = [
    "${repository}:latest",
    "${repository}:bullseye",
    "${repository}:${version}",
  ]
}
