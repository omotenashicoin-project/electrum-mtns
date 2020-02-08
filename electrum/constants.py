# -*- coding: utf-8 -*-
#
# Electrum - lightweight Omotenashicoin client
# Copyright (C) 2018 The Electrum developers
# Copyright (C) modified by Omotenashicoin Project
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import json

from .util import inv_dict


def read_json(filename, default):
    path = os.path.join(os.path.dirname(__file__), filename)
    try:
        with open(path, 'r') as f:
            r = json.loads(f.read())
    except:
        r = default
    return r


GIT_REPO_URL = "https://github.com/omotenashicoin-project/electrum-mtns"
GIT_REPO_ISSUES_URL = "https://github.com/omotenashicoin-project/electrum-mtns/issues"


class AbstractNet:

    @classmethod
    def max_checkpoint(cls) -> int:
        return max(0, len(cls.CHECKPOINTS) * 2016 - 1)

class BitcoinMainnet(AbstractNet):

    TESTNET = False
    WIF_PREFIX = 191
    ADDRTYPE_P2PKH = 63
    ADDRTYPE_P2SH = 18
    SEGWIT_HRP = ""
    GENESIS = "00000e04317329056e236da90ebbd1cafacf2cbe1337509231289677cec3f192"
    DEFAULT_PORTS = {'t': '50001', 's': '50002'}
    DEFAULT_SERVERS = read_json('servers.json', {})
    CHECKPOINTS = read_json('checkpoints.json', [])

    XPRV_HEADERS = {
        'standard':    0x03A395DA,
    }
    XPRV_HEADERS_INV = inv_dict(XPRV_HEADERS)
    XPUB_HEADERS = {
        'standard':    0x03A39555,
    }
    XPUB_HEADERS_INV = inv_dict(XPUB_HEADERS)
    BIP44_COIN_TYPE = 341


class BitcoinTestnet(AbstractNet):

    TESTNET = True
    WIF_PREFIX = 193
    ADDRTYPE_P2PKH = 83
    ADDRTYPE_P2SH = 18
    SEGWIT_HRP = ""
    GENESIS = "000001780e5aa2fa2df9e9e8a4e86f40261cd5851134c236b32e767e58b12dc6"
    DEFAULT_PORTS = {'t': '51001', 's': '51002'}
    DEFAULT_SERVERS = read_json('servers_testnet.json', {})
    CHECKPOINTS = read_json('checkpoints_testnet.json', [])

    XPRV_HEADERS = {
        'standard':    0x04346B86,
    }
    XPRV_HEADERS_INV = inv_dict(XPRV_HEADERS)
    XPUB_HEADERS = {
        'standard':    0x04346B01,
    }
    XPUB_HEADERS_INV = inv_dict(XPUB_HEADERS)
    BIP44_COIN_TYPE = 1


class BitcoinRegtest(BitcoinTestnet):

    SEGWIT_HRP = ""
    GENESIS = "000004e7b00f32cdc9b02864181ab996fc003d3ed1bdb1377ba1a6b30f35cab2"
    DEFAULT_SERVERS = read_json('servers_regtest.json', {})
    CHECKPOINTS = []


class BitcoinSimnet(BitcoinTestnet):

    SEGWIT_HRP = ""
    GENESIS = ""
    DEFAULT_SERVERS = read_json('servers_regtest.json', {})
    CHECKPOINTS = []



# don't import net directly, import the module instead (so that net is singleton)
net = BitcoinMainnet

def set_simnet():
    global net
    net = BitcoinSimnet

def set_mainnet():
    global net
    net = BitcoinMainnet


def set_testnet():
    global net
    net = BitcoinTestnet


def set_regtest():
    global net
    net = BitcoinRegtest
