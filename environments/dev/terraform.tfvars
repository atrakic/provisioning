# dev.tfvars

project_name    = "dev"

hcloud_location = "nbg1"  # Nuremberg DC Park 1

apt_packages    = ["curl","git","htop", "whois"]

#hcloud_image    = "ubuntu-18.04"

labels          = { env = "dev" }
