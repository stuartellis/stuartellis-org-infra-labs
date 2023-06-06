# Default Makefile

# Configuration for Make

SHELL := /bin/sh
.ONESHELL:
.SHELLFLAGS := -u -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

### Required for Terraform

PROJECT_DIR				:= $(shell pwd)
ENVIRONMENT				?= dev

PRODUCT_NAME			:= labs

include make/terraform/*.mk
