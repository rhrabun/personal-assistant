# Run `make` to see commands

.PHONY: help up down restart stop start status logs setup hermes-logs executor-logs
.DEFAULT_GOAL := help

COMPOSE := docker compose

help: ## Show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Stack
up: ## Start stack (pull + up)
	$(COMPOSE) pull
	$(COMPOSE) up -d
down: ## Stop and remove containers (data kept)
	$(COMPOSE) down
restart: ## Restart whole stack
	$(COMPOSE) restart
stop: ## Stop containers (keep them)
	$(COMPOSE) stop
start: ## Start containers (no pull)
	$(COMPOSE) start
status: ## Container status
	$(COMPOSE) ps
logs: ## Follow all logs
	$(COMPOSE) logs -f --tail 100

##@ Hermes
setup: ## Configure hermes agent
	$(COMPOSE) exec -it hermes hermes setup
hermes-logs: ## Follow hermes logs
	$(COMPOSE) logs -f --tail 100 hermes

##@ Executor
executor-logs: ## Follow executor logs
	$(COMPOSE) logs -f --tail 100 executor
