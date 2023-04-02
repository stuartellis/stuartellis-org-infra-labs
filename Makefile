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

include make/terraform/*.mk
