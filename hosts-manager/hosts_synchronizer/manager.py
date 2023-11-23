'''
Tools to manage a hosts file
'''

import logging
import os
import re
import shutil
from typing import Iterable, List

from python_hosts.hosts import Hosts, HostsEntry

LOGGER = logging.getLogger(__name__)


class IpHostsManager:
    '''
    A tool to update a hosts file with hostnames pointing to a given IP
    '''

    def __init__(self):
        '''
        Args:
            ip: IP to point the hosts to, defaults to the loopback IPv4 address

        Environment variables:
            $HOSTS_IP (optional): IP to point the hosts to. Defaults to 127.0.0.1
            $HOSTS_PATTERN: pattern to determine the hosts that will be managed by this tool.
            $HOSTS_PATH: path to the diretory containing the hosts file. Defaults to the platform-specific one
        '''
        self.ip = os.environ.get('HOSTS_IP') or '127.0.0.1'
        self.pattern = re.compile(os.environ['HOSTS_PATTERN'])

        hosts_path = os.environ.get('HOSTS_PATH') or os.path.dirname(Hosts.determine_hosts_path())
        self.location = os.path.join(hosts_path, 'hosts')

    def sync(self, new_hosts: Iterable[str]):
        '''
        Args:
            new_hosts: new hostnames to set. Hosts not matching $HOSTS_PATTERN are ignored.
        '''
        new_hosts = list(sorted(set(h for h in new_hosts if self.pattern.match(h))))

        LOGGER.info('reading hosts file at %s', self.location)
        hosts_file = Hosts(path=self.location)
        entries: List[HostsEntry] = hosts_file.entries or []

        # remove all current matching hostnames
        names_to_remove = set()
        for entry in entries:
            for name in (entry.names or []):
                if self.pattern.match(name):
                    names_to_remove.add(name)

        names_to_remove = list(sorted(names_to_remove))
        LOGGER.info('removing current hostnames %s', names_to_remove)
        for name in names_to_remove:
            hosts_file.remove_all_matching(name=name)

        LOGGER.info('adding new hostnames %s pointing to %s', names_to_remove, self.ip)
        # add the new ones
        for host in new_hosts:
            entry = HostsEntry(
                entry_type='ipv4',
                names=[host],
                address=self.ip,
                comment='added by hosts-manager',
            )
            hosts_file.add(
                entries=[entry],
                allow_address_duplication=True,
                merge_names=False,
                )

        # make a backup before changing anything
        bkp_path = self.location + '.bkp'
        LOGGER.info('backing up the hosts file to %s', bkp_path)
        shutil.copy(src=self.location, dst=bkp_path)

        # write to a temporary path beforehand. I'm not using tempfile because
        # writing to the same directory assures we're in the same filesystem
        # and therefore moves are atomic
        tmp_path = self.location + '.tmp'
        LOGGER.info('writing the new hosts file to %s', tmp_path)
        hosts_file.write(path=tmp_path)

        LOGGER.info('moving new hosts to %s', self.location)
        shutil.move(src=tmp_path, dst=self.location)

        LOGGER.info('done')
