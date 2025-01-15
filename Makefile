ifeq ($(ENV),prod)
	ENVIRONMENT = prod
else ifeq ($(ENV),stage)
  ENVIRONMENT = stage
else
  ENVIRONMENT = stage
endif

#### DEBUG ####
print_var:
	echo $(ENVIRONMENT)
	echo $(TF_BACKEND_CONFIG)
	echo $(TF_ENV_FILE)

#### MAIN ####
## Terraform ##
TF_BACKEND_CONFIG = ./envs/$(ENVIRONMENT)/backend.tfbackend
TF_ENV_FILE = ./envs/$(ENVIRONMENT)/variables.tfvars

terraform-init:
	cd ./terraform && \
	terraform get && \
	terraform init -backend-config=$(TF_BACKEND_CONFIG)

terraform-plan:
	cd ./terraform && \
	terraform plan -var-file=$(TF_ENV_FILE)

terraform-apply:
	cd ./terraform && \
	terraform apply -var-file=$(TF_ENV_FILE)

terraform-destroy:
	cd ./terraform && \
	terraform apply -destroy -var-file=$(TF_ENV_FILE)

## Ansible ##
ANSIBLE_HOSTS_FILE = ./inventories/$(ENVIRONMENT)/hosts.ini
ANSIBLE_VARS_FILE = ./inventories/$(ENVIRONMENT)/variables.yaml

ansible-deploy:
	cd ./ansible && \
	ansible-galaxy install -r requirements.yml && \
	ansible-playbook bootstrap.yml \
		-i $(ANSIBLE_HOSTS_FILE) \
		-e @$(ANSIBLE_VARS_FILE) \
		-e @./inventories/.ansible_secret.yaml

ansible-deploy-with-tag:
	cd ./ansible && \
	ansible-galaxy install -r requirements.yml && \
	ansible-playbook bootstrap.yml \
		-i $(ANSIBLE_HOSTS_FILE) \
		-e @$(ANSIBLE_VARS_FILE) \
		-e @./inventories/.ansible_secret.yaml \
		-t $(TAG)