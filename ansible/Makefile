# Run `make` to see commands

.PHONY: help run dry-run
.DEFAULT_GOAL := help

INV := -i inventory.yml

help: ## Show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

run: ## Run deploy playbook
	ansible-playbook deploy.yml $(INV)

dry-run: ## Dry-run deploy playbook
	ansible-playbook deploy.yml $(INV) --check --diff