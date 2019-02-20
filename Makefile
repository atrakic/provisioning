# Makefile

.PHONY: all

all: install init update plan

ENVIRONMENT ?= dev
COMMIT = $(shell git rev-parse --short HEAD)

TERRAFORM := $(shell pwd)/terraform
TMP ?= /tmp
OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
TERRAFORM_VERSION ?= 0.11.11
TERRAFORM_URL ?= https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS)_amd64.zip

HCLOUD := $(shell pwd)/hcloud
HCLOUD_VERSION ?= 1.12.0

install: ## Install terraform
	@[ -x $(TERRAFORM) ] || ( \
	echo "Installing terraform $(TERRAFORM_VERSION) ($(OS)) from $(TERRAFORM_URL)" && \
	curl '-#' -fLo $(TMP)/terraform.zip $(TERRAFORM_URL) && \
	unzip -q -d $(TMP)/ $(TMP)/terraform.zip && \
	mv $(TMP)/terraform $(TERRAFORM) && \
	rm -f $(TMP)/terraform.zip \
	)

init:
	rm -rf .terraform/modules/
	terraform init -reconfigure

plan: init update
	terraform plan \
		-input=false \
		-module-depth=-1 \
		-refresh=true \
		-state=environments/$(ENVIRONMENT)/terraform.tfstate \
		-var-file=environments/$(ENVIRONMENT)/terraform.tfvars

plan-output: init update ## Write a plan file to the given commit. This can be used as input to the "apply" command
	terraform plan \
      -input=true \
      -refresh=true \
      -var-file=environments/$(ENVIRONMENT)/terraform.tfvars \
      -out=environments/$(ENVIRONMENT)/$(COMMIT).tfplan

apply: update init
	terraform apply -auto-approve \
		-state=environments/$(ENVIRONMENT)/terraform.tfstate \
		-var-file=environments/$(ENVIRONMENT)/terraform.tfvars

apply-from-plan: update init plan-output
#	terraform apply \
#		-state=environments/$(ENVIRONMENT)/terraform.tfstate \
#		-var-file=environments/$(ENVIRONMENT)/terraform.tfvars\
#		environments/$(ENVIRONMENT)/$(COMMIT).tfplan

clean: init
	terraform destroy #-force

show: init
	@terraform show \
		-module-depth=-1 \
		environments/$(ENVIRONMENT)/terraform.tfstate

update:
	@terraform get -update=true 1>/dev/null

docs:
	terraform-docs md . > README.md

graph:
	@rm -f graph.png
	@terraform graph -draw-cycles -module-depth=-1 | dot -Tpng > graph.png
	@shotwell graph.png

validate:  update
	terraform fmt -check=true -diff=true
	terraform validate -check-variables=true .
