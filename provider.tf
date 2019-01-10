terraform {
  required_version = ">= 0.11.10"
}

provider "hcloud" {
   version = ">=  1.7.0"
}

provider "external" {
  version = "1.0.0"
}

provider "local" {
  version = "1.0.0"
}

provider "null" {
  version = "1.0.0"
}

provider "random" {
  version = "1.0.0"
}

provider "template" {
  version = "1.0.0"
}

#provider "tls" {
#  version = "1.0.0"
#}
