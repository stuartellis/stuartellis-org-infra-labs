.PHONY: pre-commit-check
pre-commit-check:
	pre-commit run --all-files --show-diff-on-failure
