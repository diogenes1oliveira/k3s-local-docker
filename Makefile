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

.PHONY: setup
setup:
	helmfile apply

.PHONY: kube/config
kube/config:
	curl -kLv -u $(CLUSTER_USERNAME):$(CLUSTER_PASSWORD) https://$(CLUSTER_EXTERNAL_HOSTNAME)/dashboard/.kube/config | .dev/kubeconfig-fix.py > $(KUBECONFIG)
	curl -kL http://$(CLUSTER_EXTERNAL_HOSTNAME)/.well-known/pki-validation/ca-install-trust.sh | bash -s http://$(CLUSTER_EXTERNAL_HOSTNAME)/.well-known/pki-validation/ca.pem
