'''
Tools to interface with the Kubernetes cluster
'''

import logging
import os
from typing import Iterable, List, Set

from kubernetes import config, client

LOGGER = logging.getLogger(__name__)

def k8s_configure() -> client.ApiClient:
    '''
    Configure the Kubernetes default connection

    Environment variables:
        $KUBECONFIG: path to the kube config file
        $CONTEXT (optional): name of the kube context to use
        $CLUSTER_CONNECT_PROXY (optional): will use this proxy to connect to the Kubernetes cluster. If given,
            this will also update the $http_proxy and $https_proxy environment variables
    
    Returns:
        The new Kubernetes API client
    '''
    kubeconfig = os.environ['KUBECONFIG']
    context = os.environ.get('CONTEXT')
    http_proxy = os.environ.get('CLUSTER_CONNECT_PROXY')

    config.load_kube_config(config_file=kubeconfig,
                            context=context)

    if http_proxy:
        LOGGER.info('using http proxy %s', http_proxy)
        from kubernetes import client
        client.Configuration._default.proxy = http_proxy
        os.environ['http_proxy'] = http_proxy
        os.environ['https_proxy'] = http_proxy
    else:
        LOGGER.info('connecting directly to the Kubernetes API')
    
    return client.ApiClient(configuration=client.Configuration._default)


def list_ingress_hostnames(api_client: client.ApiClient) -> List[str]:
    '''
    Lists all hostnames of all ingresses across all namespaces

    Args:
        v1: Kubernetes client object
    
    Returns:
        list: unique sorted ingress hostnames
    '''
    v1 = client.CoreV1Api(api_client=api_client)
    found_hostnames: Set[str] = set()

    LOGGER.info('listing Kubernetes namespaces')

    for item in v1.list_namespace().items:
        namespace = item.metadata.name
        for hostname in list_namespaced_ingress_hostnames(api_client, namespace):
            found_hostnames.add(hostname)

    return list(sorted(found_hostnames))


def list_namespaced_ingress_hostnames(api_client: client.ApiClient, namespace: str) -> Iterable[str]:
    '''
    Lists all hostnames of all ingresses in a specific namespace

    Args:
        v1: Kubernetes client object
        namespace: name of the name space
    
    Yields:
        str: found ingress hostname
    '''
    networking_v1 = client.NetworkingV1Api(api_client=api_client)

    LOGGER.info('listing ingresses in namespace=%s', namespace)
    ingresses = networking_v1.list_namespaced_ingress(namespace).items
    for ingress in ingresses:
        for rule in ingress.spec.rules:
            yield rule.host
