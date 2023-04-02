
## Variables for Stacks ##

STACK_NAME          ?= NONE
STACK_VARIANT       ?= default
ST_STACKS_DEFS_DIR	:= $(PROJECT_DIR)/terraform1/stacks/definitions

## Variables for Terraform ##

TF_ROOT       := $(ST_STACKS_DEFS_DIR)/$(STACK_NAME)
TF_PLAN_CACHE	:= $(TF_ROOT)/plan.cache
TF_PLAN_JSON	:= $(TF_ROOT)/plan.json 
TF_STATE_NAME	:= $(PRODUCT_NAME)-$(ENVIRONMENT)-$(STACK_NAME)-$(STACK_VARIANT)
TF_VARS_OPT	  := -var="product_name=$(PRODUCT_NAME)" stack_name=$(STACK_NAME)" -var="environment=$(ENVIRONMENT)" -var="variant=$(STACK_VARIANT)"

##  Variables for GitLab ##

ifdef CI
  TF_ADDRESS        := https://gitlab.com/api/v4/projects/$(CI_PROJECT_ID)/terraform/state/$(TF_STATE_NAME)
  TF_USERNAME       := "gitlab-ci-token"
  TF_PASSWORD       := $(CI_JOB_TOKEN)
  TF_IN_AUTOMATION 	:= true

  TF_RUN_CMD  := terraform init

  TF_RUN_CMD 				:= terraform init \
  -backend-config=address=$(TF_ADDRESS) \
  -backend-config=lock_address=$(TF_ADDRESS)/lock \
  -backend-config=unlock_address=$(TF_ADDRESS)/lock \
  -backend-config=username=$(TF_USERNAME) \
  -backend-config=password=$(TF_PASSWORD) \
  -backend-config=lock_method=POST \
  -backend-config=unlock_method=DELETE \
  -backend-config=retry_wait_min=5

else
    TF_RUN_CMD  := terraform init
endif

## Targets ##

.PHONY: terraform-init
terraform-init:
	echo $(TF_RUN_CMD) $(TF_VARS_OPT)
