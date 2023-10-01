
FPM_DOCKER_BUILD_CMD		:= podman build
FPM_DOCKER_CPU_ARCH			:= amd64
FPM_DOCKER_PLATFORM			:= linux/$(FPM_DOCKER_CPU_ARCH)
FPM_DOCKER_FILE				:= $(PROJECT_DIR)/docker/tools/fpm/Dockerfile
FPM_DOCKER_IMAGE_VERSION	:= 0.1.0
FPM_DOCKER_IMAGE_TAG		:= fpm-runner:$(FPM_DOCKER_IMAGE_VERSION)
FPM_DOCKER_IMAGE_BASE		:= ubuntu:focal


.PHONY fpm-create-runner:
fpm-create-runner:
	$(FPM_DOCKER_BUILD_CMD) --platform $(FPM_DOCKER_PLATFORM) -f $(FPM_DOCKER_FILE) -t $(FPM_DOCKER_IMAGE_TAG) \
	--build-arg DOCKER_IMAGE_BASE=$(FPM_DOCKER_IMAGE_BASE) \
    --label org.opencontainers.image.version=$(FPM_DOCKER_IMAGE_VERSION)
