# Run `make` to see commands

.PHONY: help run dry-run
.DEFAULT_GOAL := help

# User (inventory host) to target; default all.
user ?= all

help: ## Show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

run: ## Run deploy playbook (make run user=<user>)
	ansible-playbook deploy.yml --limit $(user) --ask-vault-pass

dry-run: ## Dry-run deploy playbook (make dry-run user=<user>)
	ansible-playbook deploy.yml --check --diff --limit $(user) --ask-vault-pass
