# Default Makefile

# Configuration for Make

SHELL := /bin/sh
.ONESHELL:
.SHELLFLAGS := -eu -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

### Required for Terraform

PROJECT_DIR				:= $(shell pwd)
ENVIRONMENT				?= dev

PRODUCT_NAME			:= labs

include make/pre-commit/*.mk
include make/terraform/*.mk
