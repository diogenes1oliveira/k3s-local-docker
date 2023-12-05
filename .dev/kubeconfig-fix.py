#!/usr/bin/env python3

import os
import sys
import yaml

config = yaml.load(sys.stdin.read(), Loader=yaml.SafeLoader)

hostname = os.environ["CLUSTER_EXTERNAL_HOSTNAME"]
config["clusters"][0]["cluster"]["server"] = f"https://{hostname}:6443"

proxy = os.getenv("CLUSTER_CONNECT_PROXY")
if proxy:
    config["clusters"][0]["cluster"]["proxy-url"] = proxy

print(yaml.dump(config))
print()
