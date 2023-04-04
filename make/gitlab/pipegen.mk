
## Targets ##

.PHONY: pipegen-get-ytt
pipegen-get-ytt:
	apk add ytt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

.PHONY: pipegen-build
pipegen-build:
	echo "Hello world" > tmp/generated-config.yml
