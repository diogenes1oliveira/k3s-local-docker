DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose

.PHONY: compose/up
compose/up:
	$(DOCKER_COMPOSE) up -d
	.dev/wait-for-cluster.sh

.PHONY: compose/rm
compose/rm:
	$(DOCKER_COMPOSE) rm -fsv
	$(DOCKER_COMPOSE) down -v || true
	$(DOCKER) volume prune -f
	$(DOCKER) network prune -f
	.dev/clean.sh

.PHONY: hosts/up
hosts/up:
	cd ./hosts-manager && $(DOCKER_COMPOSE) up -d
	$(MAKE) hosts/logs

.PHONY: hosts/logs
hosts/logs:
	cd ./hosts-manager && \
	$(DOCKER_COMPOSE) logs -f

hosts/rm:
	cd ./hosts-manager && \
	$(DOCKER_COMPOSE) rm -fsv && \
	( $(DOCKER_COMPOSE) down -v || true ) && \
	$(DOCKER) volume prune -f && \
	$(DOCKER) network prune -f
