
PIPEGEN_TEMPLATE_ROOT_DIR := .gitlab/ci/templates
PIPEGEN_TARGET_DIR := tmp/pipegen

## Targets ##

.PHONY: pipegen-get-ytt
pipegen-get-ytt:
	apk add ytt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

.PHONY: pipegen-build
pipegen-build:
	mkdir -p $(PIPEGEN_TARGET_DIR)
	cp $(PIPEGEN_TEMPLATE_ROOT_DIR)/check/terraform/.gitlab-ci.yml > $(PIPEGEN_TARGET_DIR)/.gitlab-ci.yml
