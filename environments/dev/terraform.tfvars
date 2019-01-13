# dev.tfvars
project_name="dev"
hcloud_location="nbg1"  # Nuremberg DC Park 1
apt_packages=["curl","git","htop","ansible"]
labels = {
  env = "dev" 
}
#user_data = "echo 'StrictModes yes' >> /etc/ssh/sshd_config" 
