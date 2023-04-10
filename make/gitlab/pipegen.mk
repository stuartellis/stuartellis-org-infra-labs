
## Constants

PIPEGEN_TEMPLATE_ROOT_DIR := .gitlab/ci/templates
PIPEGEN_TARGET_ROOT_DIR := tmp/pipegen

## User Options

PIPEGEN_TASK 				?= pipegen
PIPEGEN_VARS_PREFIX			?= $(shell echo $(PIPEGEN_TASK) | tr '[:lower:]' '[:upper:]' | tr - _)

## Calculated variables

PIPEGEN_TEMPLATE_SRC_PATH	:= $(PIPEGEN_TEMPLATE_ROOT_DIR)/$(PIPEGEN_TASK)/.gitlab-ci.yml
PIPEGEN_TARGET_OUTPUT_DIR	:= $(PIPEGEN_TARGET_ROOT_DIR)/$(PIPEGEN_TASK)

## Targets ##

.PHONY: pipegen-clean
pipegen-clean:
	@rm -r $(PIPEGEN_TARGET_ROOT_DIR)

.PHONY: pipegen-get-ytt
pipegen-get-ytt:
	@apk add ytt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

.PHONY: pipegen-build
pipegen-build:
	mkdir -p $(PIPEGEN_TARGET_OUTPUT_DIR)
	ytt -f $(PIPEGEN_TEMPLATE_SRC_PATH) --data-values-env $(PIPEGEN_VARS_PREFIX) --output-files $(PIPEGEN_TARGET_OUTPUT_DIR)

.PHONY: pipegen-info
pipegen-info:
	@echo "Environment variable prefix: $(PIPEGEN_VARS_PREFIX)"
