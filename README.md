# k3s-local-docker

Start and configure a local persistent k3s instance using docker

## Requirements

Copy the `.env.example` and make the necessary adjustments:

```shell
cp .env.example .env
vi .env
```

You also need to have the following programs installed:

- [Docker](https://www.docker.com/)
- [Helm](https://helm.sh/)
- [Helmfile](https://github.com/helmfile/helmfile)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)

You can setup Helm, Helmfile and Kubectl using the script below:

```shell
# OUTPUT_DIR is a directory in your $PATH
.dev/setup-deps.sh OUTPUT_DIR
```

## Installing

Start with `docker-compose`:

```shell
make compose/up
```

## Configuring

```shell
make setup
```

## Destroying

```shell
make compose/rm
```

## Trust

Visite a página <http://$CLUSTER_EXTERNAL_HOSTNAME/.well-known/pki-validation/ca-trust.txt>, onde `$CLUSTER_EXTERNAL_HOSTNAME` é o
endereço externo da máquina:

```shell
echo "http://$CLUSTER_EXTERNAL_HOSTNAME/.well-known/pki-validation/ca-trust.txt" 
```

## Kubeconfig

Faça o download do kubeconfig em http://$CLUSTER_EXTERNAL_HOSTNAME/dashboard/.kube/config
