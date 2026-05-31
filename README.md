
ec2-aws-monitoring
Terraform + Ansible project to provision AWS EC2 instances and configure Prometheus + Grafana.

Terraform: VPC, public subnet, Internet Gateway, route table, security group, EC2 instances (targets + promgraf).
Ansible: installs node_exporter on targets and Prometheus + Grafana on promgraf.
Contents
terraform/
providers.tf
variables.tf
security.tf
main.tf
outputs.tf
ansible/
inventory.ini.example
generate_inventory.sh
playbook.yml
roles/
prometheus/ (tasks, templates, files)
grafana/ (tasks, templates, files)
Prerequisites
AWS credentials configured (env or profile)
Terraform >= 1.1
Ansible >= 2.9 (control host: Linux or WSL2 recommended)
jq
ssh client and an EC2 key pair (key_name)
High-level workflow
Edit terraform/variables.tf or pass vars on CLI (notably key_name and aws_region).
Deploy infra:
bash

Collapse


 Copy

terraform init
terraform apply -var="key_name=YOUR_KEY" -auto-approve
Export TF outputs:
bash

Collapse


 Copy

terraform output -json > tf_outputs.json
Generate Ansible inventory:
bash

Collapse


 Copy

cd ansible
./generate_inventory.sh ../tf_outputs.json ~/.ssh/YOUR_KEY.pem > inventory.ini
Prepare control host (WSL2 recommended):
bash

Collapse


 Copy

sudo apt update && sudo apt install -y python3 python3-venv python3-pip ssh jq
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate
pip install --upgrade pip
pip install ansible
Ensure remote Python >= 3.8 (example Amazon Linux 2):
bash

Collapse


 Copy

sudo yum install -y python38
# set interpreter in inventory or group_vars:
ansible_python_interpreter=/usr/bin/python3.8
Test connectivity:
bash

Collapse


 Copy

ansible -i inventory.ini all -m ping -u ec2-user --private-key ~/.ssh/YOUR_KEY.pem
Run playbook:
bash

Collapse


 Copy

ansible-playbook -i inventory.ini playbook.yml -u ec2-user --private-key ~/.ssh/YOUR_KEY.pem
Defaults & Notes
Subnet uses map_public_ip_on_launch = true so instances receive public IPs.
Security group opens SSH (22), node_exporter (9100 internal), Prometheus (9090) and Grafana (3000). Tighten CIDR blocks in production.
Prometheus config is generated from inventory group [targets] (static_configs). Consider EC2 SD for dynamic environments.
Grafana provisioning creates a Prometheus datasource pointing to local Prometheus. Default admin/admin — change in production.
Troubleshooting
"os.get_blocking" error on Windows: run Ansible from WSL2 or Linux.
SyntaxError in remote modules: ensure remote Python >= 3.8 and set ansible_python_interpreter.
SSH errors: check security group inbound rules, key permissions (chmod 600), correct ansible_user (ec2-user vs ubuntu).
Cleanup
bash

Collapse


 Copy

terraform destroy -var="key_name=YOUR_KEY" -auto-approve
Customization
Change AMI lookup to use Amazon Linux 2023 via data.aws_ami or SSM parameter.
Use private subnets + bastion for production.
Switch Prometheus/Grafana to containers (Docker/ECS) if preferred.
License
MIT
