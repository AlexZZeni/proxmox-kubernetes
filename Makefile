ENVIRONMENT = $(ENV)
ENVIRONMENT_PREFIX = $(word 1,$(subst _, ,$(ENV)))

#### DEBUG ####
print_vars:
	@echo "ENVIRONMENT: $(ENVIRONMENT)"
	@echo "TF_BACKEND_CONFIG: $(TF_BACKEND_CONFIG)"
	@echo "TF_ENV_FILE: $(TF_ENV_FILE)"
	@echo "ANSIBLE_HOSTS_FILE: $(ANSIBLE_HOSTS_FILE)"
	@echo "ANSIBLE_VARS_FILE: $(ANSIBLE_VARS_FILE)"
	@echo "ANSIBLE_SECRET_FILE: $(ANSIBLE_SECRET_FILE)"
	@echo "ENVIRONMENT_PREFIX: $(ENVIRONMENT_PREFIX)"


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
ANSIBLE_HOSTS_FILE = ./inventories/envs/$(ENVIRONMENT)/hosts.ini
ANSIBLE_VARS_FILE = ./inventories/envs/$(ENVIRONMENT)/variables.yaml
ANSIBLE_SECRET_FILE = ./inventories/envs/$(ENVIRONMENT)/.ansible_secret.yaml

ansible-deploy:
	cd ./ansible && \
	ansible-galaxy install -r requirements.yaml && \
	ansible-playbook $(ENVIRONMENT_PREFIX)_bootstrap.yaml \
		-i $(ANSIBLE_HOSTS_FILE) \
		-e @$(ANSIBLE_VARS_FILE) \
		-e @$(ANSIBLE_SECRET_FILE) 

ansible-deploy-with-tag:
	cd ./ansible && \
	ansible-galaxy install -r requirements.yaml && \
	ansible-playbook $(ENVIRONMENT_PREFIX)_bootstrap.yaml \
		-i $(ANSIBLE_HOSTS_FILE) \
		-e @$(ANSIBLE_VARS_FILE) \
		-e @$(ANSIBLE_SECRET_FILE)  \
		-t $(TAG)