# Makefile - Comandos para gestionar el contenedor 'mailer' y el repositorio Git

# -----------------------------
# Variables
# -----------------------------
SERVICE := mailer

# -----------------------------
# Docker Compose
# -----------------------------

# Construye y levanta el contenedor en segundo plano
up:
	docker-compose up -d --build

# Detiene y elimina el contenedor
down:
	docker-compose down

# Inicia el contenedor si ya está creado
start:
	docker start $(SERVICE)

# Detiene el contenedor
stop:
	docker stop $(SERVICE)

# Reinicia el contenedor
restart:
	docker restart $(SERVICE)

# Muestra logs en tiempo real
logs:
	docker logs -f $(SERVICE)

# -----------------------------
# Git
# -----------------------------

# Ejemplo: make push "mensaje del commit"
push:
	@if [ -z "$(filter-out push,$(MAKECMDGOALS))" ]; then \
		echo "Debe incluir un mensaje de commit entre comillas."; \
		exit 1; \
	fi
	git add .
	git commit -m "$(filter-out push,$(MAKECMDGOALS))"
	git push origin main

# -----------------------------
# Ayuda
# -----------------------------
help:
	@echo "Comandos disponibles:"
	@echo "  make up        - Levanta el contenedor mailer"
	@echo "  make down      - Elimina el contenedor mailer"
	@echo "  make start     - Inicia el contenedor detenido"
	@echo "  make stop      - Detiene el contenedor"
	@echo "  make restart   - Reinicia el contenedor"
	@echo "  make logs      - Muestra los logs"
	@echo "  make push \"mensaje\" - Hace commit y push a main"
