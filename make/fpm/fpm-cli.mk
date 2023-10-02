FPM_DOCKER_CPU_ARCH			:= amd64
FPM_VERSION					:= 1.15.1
FPM_DOCKER_IMAGE_VERSION	:= $(FPM_VERSION)-202310020740z
FPM_DOCKER_IMAGE_BASE		:= ubuntu:focal
FPM_OUTPUT_DIR				:= $(PROJECT_DIR)/tmp
APP_NAME					:= ansible
PKG_NAME					:= $(APP_NAME)
PKG_VERSION					:= 0.1.0

FPM_CONTAINER_BUILD_DIR		:= /app/src
FPM_CONTAINER_OUTPUT_DIR	:= /app/out

APP_SRC_DIR					:= $(PROJECT_DIR)/$(APP_NAME)
FPM_BUILD_CMD				:= fpm --verbose -s dir -t deb -n $(PKG_NAME) -C $(FPM_CONTAINER_BUILD_DIR) -p $(FPM_CONTAINER_OUTPUT_DIR) --deb-compression bzip2 --version $(PKG_VERSION) .=/opt/$(PKG_NAME)

FPM_DOCKER_BUILD_CMD		:= podman build
FPM_DOCKER_RUN_CMD			:= podman run
FPM_DOCKER_PLATFORM			:= linux/$(FPM_DOCKER_CPU_ARCH)
FPM_DOCKER_FILE				:= $(PROJECT_DIR)/docker/tools/fpm/Dockerfile
FPM_DOCKER_IMAGE_TAG		:= fpm:$(FPM_DOCKER_IMAGE_VERSION)
FPM_UID 					:= $(shell id -u)
FPM_DOCKER_OPTS				:= --mount type=bind,source=$(APP_SRC_DIR),destination=$(FPM_CONTAINER_BUILD_DIR) \
	--mount type=bind,source=$(FPM_OUTPUT_DIR),destination=$(FPM_CONTAINER_OUTPUT_DIR) \
	-w $(FPM_CONTAINER_BUILD_DIR) --privileged

.PHONY fpm-create-runner:
fpm-create-runner:
	@$(FPM_DOCKER_BUILD_CMD) --platform $(FPM_DOCKER_PLATFORM) -f $(FPM_DOCKER_FILE) -t $(FPM_DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(FPM_DOCKER_IMAGE_BASE) \
	--build-arg FPM_VERSION=$(FPM_VERSION) \
    --label org.opencontainers.image.version=$(FPM_DOCKER_IMAGE_VERSION)

.PHONY fpm-build:
fpm-build: ansible-vendor
	@cd $(APP_SRC_DIR)
	@$(FPM_DOCKER_RUN_CMD) --rm $(FPM_DOCKER_OPTS) $(FPM_DOCKER_IMAGE_TAG) $(FPM_BUILD_CMD)

.PHONY fpm-shell:
fpm-shell:
	@cd $(APP_SRC_DIR)
	@$(FPM_DOCKER_RUN_CMD) --rm -it $(FPM_DOCKER_OPTS) $(FPM_DOCKER_IMAGE_TAG) /bin/sh

.PHONY ansible-vendor:
ansible-vendor: fpm-venv
	@cd $(APP_SRC_DIR)
	@ansible-galaxy collection install -r requirements.yml -p collections --no-cache

.PHONY fpm-venv:
fpm-venv:
	@cd $(APP_SRC_DIR)
	@python3 -m venv .venv
	@source .venv/bin/activate
	@python3 -m pip install -r requirements.txt
