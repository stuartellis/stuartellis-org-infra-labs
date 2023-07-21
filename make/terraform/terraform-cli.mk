
## Variables for Terraform ##

TF_VERSION			:= 1.4.6
TF_CPU_ARCH			:= amd64
TF_OS_TYPE			:= linux

## Variables for Stacks ##

STACK_NAME          ?= NONE
STACK_VARIANT       ?= default
ST_STACKS_DEFS_DIR	:= $(PROJECT_DIR)/terraform1/stacks/definitions
ST_STACKS_ENVS_DIR	:= $(PROJECT_DIR)/terraform1/stacks/environments
ST_TF_BIN_DIR		:= $(PROJECT_DIR)/bin
ST_TF_TMP_DIR		:= $(PROJECT_DIR)/tmp/terraform

## Variables for Terraform ##

ST_TF_EXE			:= $(ST_TF_BIN_DIR)/terraform

# GitLab uses TF_ROOT
TF_ROOT           := $(ST_STACKS_DEFS_DIR)/$(STACK_NAME)

TF_STATE_NAME     := $(PRODUCT_NAME)-$(ENVIRONMENT)-$(STACK_NAME)-$(STACK_VARIANT)

ST_VARS_OPT       := -var="product_name=$(PRODUCT_NAME)" -var="stack_name=$(STACK_NAME)" -var="environment=$(ENVIRONMENT)" -var="variant=$(STACK_VARIANT)"
ST_VAR_FILES_OPT  := -var-file=$(ST_STACKS_ENVS_DIR)/all/$(STACK_NAME).tfvars -var-file=$(ST_STACKS_ENVS_DIR)/$(ENVIRONMENT)/$(STACK_NAME).tfvars

# Terraform plan
ST_FLAG_FILE		:= $(TF_STATE_NAME)-tf-plan-result-code.txt
ST_FLAG_PATH		:= $(ST_TF_TMP_DIR)/$(ST_FLAG_FILE)
ST_PLAN_FILE		:= $(TF_STATE_NAME).tfplan
ST_PLAN_PATH		:= $(ST_TF_TMP_DIR)/$(ST_PLAN_FILE)
ST_PLAN_OPT			:= -detailed-exitcode -out=$(ST_PLAN_PATH)

ST_TF_PLAN_JSON		:= $(ST_TF_TMP_DIR)/$(TF_STATE_NAME)-plan.json

ST_CHDIR_OPT		:= -chdir=$(TF_ROOT)
GL_TF_PLAN_FILTER 	:= jq -r '([.resouTF_PLAN_RESULT_CODEe_changes[]?.change.actions?]|flatten)|{"create":(map(select(.=="create"))|length),"update":(map(select(.=="update"))|length),"delete":(map(select(.=="delete"))|length)}'

##  Variables for GitLab ##
# TF_IN_AUTOMATION 	:= true

ifdef CI
	GL_TF_ADDRESS        := https://gitlab.com/api/v4/projects/$(CI_PROJECT_ID)/terraform/state/$(TF_STATE_NAME)
  	GL_TF_USERNAME       := "gitlab-ci-token"
  	GL_TF_PASSWORD       := $(CI_JOB_TOKEN)

	TF_HTTP_ADDRESS			:= $(GL_TF_ADDRESS)
	TF_HTTP_LOCK_ADDRESS	:= $(TF_HTTP_ADDRESS)/lock
	TF_HTTP_LOCK_METHOD		:= POST
	TF_HTTP_UNLOCK_ADDRESS	:= $(TF_HTTP_ADDRESS)/lock
	TF_HTTP_UNLOCK_METHOD   := DELETE
	TF_HTTP_USERNAME		:= $(GL_TF_USERNAME)
	TF_HTTP_PASSWORD		:= $(GL_TF_PASSWORD)
	TF_HTTP_RETRY_WAIT_MIN	:= 5

	ST_BACKEND_ENV_VARS		:= 	TF_HTTP_ADDRESS=$(TF_HTTP_ADDRESS) \
		TF_HTTP_LOCK_ADDRESS=$(TF_HTTP_LOCK_ADDRESS) \
		TF_HTTP_LOCK_METHOD=$(TF_HTTP_LOCK_METHOD) \
		TF_HTTP_UNLOCK_ADDRESS=$(TF_HTTP_UNLOCK_ADDRESS) \
		TF_HTTP_UNLOCK_METHOD=$(TF_HTTP_UNLOCK_METHOD) \
		TF_HTTP_USERNAME=$(TF_HTTP_USERNAME) \
		TF_HTTP_PASSWORD=$(TF_HTTP_PASSWORD) \
		TF_HTTP_RETRY_WAIT_MIN=$(TF_HTTP_RETRY_WAIT_MIN) \

else
	TF_RUN_CMD_OPTS			:= -backend=false
	ST_BACKEND_ENV_VARS		:=
endif

## Targets ##

.PHONY: terraform-apply
terraform-apply:
	TF_PLAN_RESULT_CODE=2
	TF_PLAN_RESULT_CODE=$$(cat $(ST_FLAG_PATH))
	if [ $$TF_PLAN_RESULT_CODE -eq 0 ]; then
		echo "INFO: no change"
	elif [ $$TF_PLAN_RESULT_CODE -eq 2 ]; then # Succeeded, there is a diff
		echo "INFO: CHANGES"
		$(ST_BACKEND_ENV_VARS) $(ST_TF_EXE) $(ST_CHDIR_OPT) apply $(ST_PLAN_PATH)
		exit 0
	else                     # Errored
		exit 1
	fi

.PHONY: terraform-check-fmt
terraform-check-fmt:
	$(ST_TF_EXE) $(ST_CHDIR_OPT) fmt -check -diff -recursive

.PHONY: terraform-destroy
terraform-destroy:
	$(ST_BACKEND_ENV_VARS) $(ST_TF_EXE) $(ST_CHDIR_OPT) apply -destroy -auto-approve $(ST_VARS_OPT) $(ST_VAR_FILES_OPT)

.PHONY: terraform-dummy
terraform-dummy:
	echo 'Dummy target'

.PHONY: terraform-fmt
terraform-fmt:
	$(ST_TF_EXE) $(ST_CHDIR_OPT) fmt

.PHONY: terraform-init
terraform-init:
	$(ST_BACKEND_ENV_VARS) $(ST_TF_EXE) $(ST_CHDIR_OPT) init $(ST_VARS_OPT)

.PHONY: terraform-plan
terraform-plan:
	mkdir -p $(ST_TF_TMP_DIR)
	TF_PLAN_RESULT_CODE=0
	$(ST_BACKEND_ENV_VARS) $(ST_TF_EXE) $(ST_CHDIR_OPT) plan $(ST_PLAN_OPT) $(ST_VARS_OPT) $(ST_VAR_FILES_OPT) || TF_PLAN_RESULT_CODE=$$?
	if [ $$TF_PLAN_RESULT_CODE -eq 0 ]; then
		echo "INFO: no change"
		echo $$TF_PLAN_RESULT_CODE > $(ST_FLAG_PATH)
	elif [ $$TF_PLAN_RESULT_CODE -eq 2 ]; then # Succeeded, there is a diff
		echo "INFO: CHANGES"
		echo $$TF_PLAN_RESULT_CODE > $(ST_FLAG_PATH)
		exit 0
	else                     # Errored
		exit 1
	fi

.PHONY: terraform-show-json
terraform-show-json:
	$(ST_TF_EXE) show --json $(ST_PLAN_PATH) | $(GL_TF_PLAN_FILTER) > $(ST_TF_PLAN_JSON)

.PHONY: terraform-install
terraform-install:
	mkdir -p $(ST_TF_BIN_DIR)
	cd $(ST_TF_BIN_DIR) && curl -L https://releases.hashicorp.com/terraform/$(TF_VERSION)/terraform_$(TF_VERSION)_$(TF_OS_TYPE)_$(TF_CPU_ARCH).zip > terraform_$(TF_VERSION)_$(TF_OS_TYPE)_$(TF_CPU_ARCH).zip
	cd $(ST_TF_BIN_DIR) && unzip terraform_$(TF_VERSION)_$(TF_OS_TYPE)_$(TF_CPU_ARCH).zip
	cd $(ST_TF_BIN_DIR) && rm terraform_$(TF_VERSION)_$(TF_OS_TYPE)_$(TF_CPU_ARCH).zip

.PHONY: terraform-flush
terraform-flush:
	@rm -r $(ST_TF_BIN_DIR)

.PHONY: terraform-validate
terraform-validate:
	@$(ST_TF_EXE) $(ST_CHDIR_OPT) validate
