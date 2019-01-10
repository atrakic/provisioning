# Makefile

.PHONY: all

all: install init update plan

ENVIRONMENT := dev
TERRAFORM := $(shell pwd)/terraform
TMP ?= /tmp
OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
TERRAFORM_VERSION ?= 0.11.11
TERRAFORM_URL ?= https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS)_amd64.zip

install: ## Install terraform
	@[ -x $(TERRAFORM) ] || ( \
	echo "Installing terraform $(TERRAFORM_VERSION) ($(OS)) from $(TERRAFORM_URL)" && \
	curl '-#' -fL -o $(TMP)/terraform.zip $(TERRAFORM_URL) && \
	unzip -q -d $(TMP)/ $(TMP)/terraform.zip && \
	mv $(TMP)/terraform $(TERRAFORM) && \
	rm -f $(TMP)/terraform.zip \
	)
init:
	rm -rf .terraform/modules/
	terraform init -reconfigure

plan: update init
	terraform plan \
		-input=false \
                -module-depth=-1 \
		-refresh=true \
	-var-file=environments/$(ENVIRONMENT).tfvars

apply: update init
	terraform apply -auto-approve \
	-var-file=environments/$(ENVIRONMENT).tfvars

check: init
	terraform plan -detailed-exitcode

clean: init
	terraform destroy -force

show: init
	@terraform show -module-depth=-1

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
