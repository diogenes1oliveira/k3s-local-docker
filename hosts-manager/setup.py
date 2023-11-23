#!/usr/bin/env python3
# -*- coding: utf8 -*-

from setuptools import setup

VERSION = "0.1.0"
DESCRIPTION = "Synchronize local hostnames to the ingresses in the Kubernetes cluster"

setup(
    name='hosts-synchronizer',
    version=VERSION,
    author='Diógenes Oliveira',
    author_email='diogenes1oliveira@gmail.com',
    url='https://github.com/diogenes1oliveira/k3s-local-docker/tree/main/hosts-manager',
    description=DESCRIPTION,
    long_description=DESCRIPTION,
    packages=['hosts_synchronizer'],
    platforms='any',
    license='MIT',
    classifiers=[
        'Programming Language :: Python',
        'Development Status :: 5 - Production/Stable',
        'Natural Language :: English',
        'Environment :: Console',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Topic :: System :: Operating System',
        'Topic :: System :: Networking',
    ],
    keywords=(
        'hosts, python, network'
    ),
)