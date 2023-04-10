
PIPEGEN_TEMPLATE_ROOT_DIR := .gitlab/ci/templates
PIPEGEN_TARGET_ROOT_DIR := tmp/pipegen

PIPEGEN_TEMPLATE_SRC_PATH	:= $(PIPEGEN_TEMPLATE_ROOT_DIR)/check/terraform/.gitlab-ci.yml
PIPEGEN_TARGET_OUTPUT_DIR	:= $(PIPEGEN_TARGET_ROOT_DIR)/check/terraform

## Targets ##

.PHONY: pipegen-get-ytt
pipegen-get-ytt:
	apk add ytt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

.PHONY: pipegen-build
pipegen-build:
	mkdir -p $(PIPEGEN_TARGET_OUTPUT_DIR)
	ytt -f $(PIPEGEN_TEMPLATE_SRC_PATH) --output-files $(PIPEGEN_TARGET_OUTPUT_DIR)
