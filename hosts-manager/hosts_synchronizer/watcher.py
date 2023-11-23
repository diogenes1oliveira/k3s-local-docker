'''
Kopf operator
'''

from hosts_synchronizer import monkeypatch


import asyncio
import logging
import kubernetes.client
import kopf

from hosts_synchronizer.k8s import k8s_configure, list_ingress_hostnames
from hosts_synchronizer.manager import IpHostsManager


LOGGER = logging.getLogger(__name__)
API_CLIENT: kubernetes.client.ApiClient
MANAGER: IpHostsManager
LOCK: asyncio.Lock


@kopf.on.startup()
async def on_startup(*_, **__):
    global API_CLIENT, MANAGER, LOCK
    LOCK = asyncio.Lock()
    API_CLIENT = k8s_configure()
    MANAGER = IpHostsManager()


@kopf.on.create('ingresses')
@kopf.on.update('ingresses')
@kopf.on.delete('ingresses')
@kopf.on.resume('ingresses')
@kopf.timer('ingresses', interval=60.0)
async def sync_hostnames(*_, **__):
    hostnames = list_ingress_hostnames(API_CLIENT)
    logging.info(f"will now regenerate ingresses for hostnames %s", hostnames)

    async with LOCK:
        MANAGER.sync(hostnames)
