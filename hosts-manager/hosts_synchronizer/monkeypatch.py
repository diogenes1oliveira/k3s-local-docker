'''
Apply monkeypatches.

This module should be called as early as possible in the program
'''

import functools
import aiohttp

aiohttp.ClientSession = functools.partial(aiohttp.ClientSession, trust_env=True)
