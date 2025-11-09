.PHONY: help build up down logs clean restart

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Construit l'image Docker
	docker compose build

up: ## Lance LibreChat
	docker compose up -d

down: ## Arrête LibreChat
	docker compose down

logs: ## Affiche les logs
	docker compose logs -f

clean: ## Nettoie les volumes et images
	docker compose down -v
	docker system prune -f

restart: ## Redémarre LibreChat
	docker compose restart

dev: ## Lance en mode développement avec logs
	docker compose up --build