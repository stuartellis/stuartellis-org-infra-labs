
## Variables for Stacks ##

STACK_NAME          ?= NONE
STACK_VARIANT       ?= default
ST_STACKS_DEFS_DIR	:= $(PROJECT_DIR)/terraform1/stacks/definitions
ST_STACKS_ENVS_DIR	:= $(PROJECT_DIR)/terraform1/stacks/environments

## Variables for Terraform ##

# GitLab uses TF_ROOT
TF_ROOT           := $(ST_STACKS_DEFS_DIR)/$(STACK_NAME)

TF_PLAN_CACHE     := $(TF_ROOT)/plan.cache
TF_PLAN_JSON      := $(TF_ROOT)/plan.json
TF_STATE_NAME     := $(PRODUCT_NAME)-$(ENVIRONMENT)-$(STACK_NAME)-$(STACK_VARIANT)
TF_VARS_OPT       := -var="product_name=$(PRODUCT_NAME)" -var="stack_name=$(STACK_NAME)" -var="environment=$(ENVIRONMENT)" -var="variant=$(STACK_VARIANT)"
TF_VAR_FILES_OPT  := -var-file=$(ST_STACKS_ENVS_DIR)/all/$(STACK_NAME).tfvars -var-file=$(ST_STACKS_ENVS_DIR)/$(ENVIRONMENT)/$(STACK_NAME).tfvars

# Terraform plan
TF_PLAN_FILE      := $(STACK_NAME)-$(ENVIRONMENT)-$(STACK_VARIANT).tfplan
TF_PLAN_PATH      := $(TF_TMP_DIR)/$(TF_PLAN_FILE)
TF_PLAN_FILE_OPT  := -out=$(TF_PLAN_PATH)

##  Variables for GitLab ##
# TF_IN_AUTOMATION 	:= true

TF_CHDIR_OPT        := -chdir=$(TF_ROOT)

ifdef CI
	TF_ADDRESS        := https://gitlab.com/api/v4/projects/$(CI_PROJECT_ID)/terraform/state/$(TF_STATE_NAME)
  	TF_USERNAME       := "gitlab-ci-token"
  	TF_PASSWORD       := $(CI_JOB_TOKEN)

  	TF_RUN_CMD_OPTS   := -backend-config=address=$(TF_ADDRESS) \
  	-backend-config=lock_address=$(TF_ADDRESS)/lock \
  	-backend-config=unlock_address=$(TF_ADDRESS)/lock \
  	-backend-config=username=$(TF_USERNAME) \
  	-backend-config=password=$(TF_PASSWORD) \
  	-backend-config=lock_method=POST \
  	-backend-config=unlock_method=DELETE \
  	-backend-config=retry_wait_min=5

else
	TF_RUN_CMD_OPTS   := -backend=false
endif

## Targets ##

.PHONY: terraform-apply
terraform-apply:
	@terraform $(TF_CHDIR_OPT) apply -auto-approve $(TF_PLAN_PATH)

.PHONY: terraform-check-fmt
terraform-check-fmt:
	@terraform $(TF_CHDIR_OPT) fmt -check -diff -recursive

.PHONY: terraform-fmt
terraform-fmt:
	@terraform $(TF_CHDIR_OPT) fmt

.PHONY: terraform-init
terraform-init:
	@terraform $(TF_CHDIR_OPT) init $(TF_RUN_CMD_OPTS) $(TF_VARS_OPT)

.PHONY: terraform-plan
terraform-plan:
	@terraform $(TF_CHDIR_OPT) plan $(TF_PLAN_FILE_OPT) $(TF_VARS_OPT) $(TF_VAR_FILES_OPT)

.PHONY: terraform-install
terraform-install:
	@apk add terraform --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
