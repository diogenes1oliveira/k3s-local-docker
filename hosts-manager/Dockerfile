ARG DOCKER_IO_MIRROR=docker.io
FROM ${DOCKER_IO_MIRROR}/library/python:3.9

ARG PIP_CONF_OVERRIDE=.dev/pip.conf
COPY "$PIP_CONF_OVERRIDE" /etc/pip.conf

ENV PIP_NO_CACHE_DIR=off \
    PIP_ROOT_USER_ACTION=ignore

WORKDIR /app
COPY ./hosts-manager/requirements.txt ./
RUN pip3 install -r requirements.txt

COPY ./hosts-manager/setup.py ./
COPY ./hosts-manager/hosts_synchronizer/ ./hosts_synchronizer/
RUN pip3 install -e .

CMD [ "kopf", "run", "/app/hosts_synchronizer/watcher.py", "-A" ]
