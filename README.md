# ckpool-solo for Unraid

Solo Bitcoin mining pool server, packaged for Unraid Community Applications.

Built on [ckpool](https://bitbucket.org/ckolivas/ckpool) by Con Kolivas — the same software used by [ckpool.org](https://ckpool.org), the largest public solo Bitcoin mining pool.

---

## What is solo mining?

When you mine through a public pool, you share block rewards with thousands of other miners in exchange for a small, steady income. With solo mining, you keep 100% of any block you find — currently 3.125 BTC — but you only get paid when your hardware actually solves a block.

Solo mining is a lottery. The more hashrate you have, the more tickets you hold. With modern ASICs and surplus power (solar, for example), it's a low-cost way to participate directly in Bitcoin's proof-of-work with no fees and no third parties.

---

## Requirements

### 1. A fully synced Bitcoin Core node

Install **Bitcoin Core (GUI)** from Unraid Community Applications. It needs to be fully synced before ckpool-solo will work.

You must enable RPC access by creating (or editing) `bitcoin.conf` in your Bitcoin Core appdata directory. The file is typically at:

```
/mnt/user/appdata/bitcoincore/.bitcoin/bitcoin.conf
```

Add the following — replace the values in angle brackets:

```ini
server=1
rpcauth=<generated-line>
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=172.17.0.0/16
```

To generate a secure `rpcauth` line, run this on any machine with Python 3:

```bash
curl -s https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py | python3 - yourusername
```

This outputs:
- An `rpcauth=...` line → paste into `bitcoin.conf`
- A password → put in your `ckpool.conf` (see below)

Restart Bitcoin Core after editing `bitcoin.conf`.

### 2. A Bitcoin wallet address

This is where block rewards are sent. Use any standard Bitcoin address (legacy, SegWit, or native SegWit/bech32). Make sure you control the private key — do not use an exchange deposit address.

### 3. A ckpool.conf file

Copy `config/ckpool.conf.example` from this repo to your Unraid appdata:

```
/mnt/user/appdata/ckpool-solo/config/ckpool.conf
```

Edit it with your values:

```json
{
  "btcd" : [{
    "url" : "172.17.0.1:8332",
    "auth" : "yourusername",
    "pass" : "the-password-from-rpcauth-output"
  }],
  "btcaddress" : "your-bitcoin-address",
  "btcsig" : "Solo Miner",
  "serverurl" : ["0.0.0.0:3333"],
  "logdir" : "/logs"
}
```

**Finding your Bitcoin Core IP:**
- If both containers are on the default `bridge` network, use your Unraid server's LAN IP (e.g. `192.168.1.10`) and port `8332`
- If you put both containers on the same custom Docker network, you can use the Bitcoin Core container name (e.g. `BitcoinCoreGUI`) instead of an IP

---

## Installation

1. Install from Unraid Community Applications — search for **ckpool-solo**
2. Set the **Config Directory** path to where you placed your `ckpool.conf`
3. Set the **Log Directory** path for ckpool log output
4. Set the **Stratum Port** (default `3333`) — this must be reachable from your miners
5. Click **Apply**

---

## Pointing your miners

Configure each ASIC with:

| Field | Value |
|-------|-------|
| Pool URL | `stratum+tcp://YOUR-UNRAID-IP:3333` |
| Worker | Anything — e.g. `rig1` or your Bitcoin address |
| Password | `x` |

ckpool ignores the worker name and password — all rewards go to the address in `ckpool.conf`.

---

## Verifying it works

Check the container logs in the Unraid UI. On a successful start you should see:

```
ckpool generator ready
Connected to bitcoind: ...
Mining from any incoming username to address bc1q...
Network diff set to ...
```

When a miner connects, you'll see a line like:

```
Stratum client 192.168.x.x connected
```

---

## Monitoring

ckpool writes detailed logs to the log directory. You can tail them from the Unraid console:

```bash
tail -f /mnt/user/appdata/ckpool-solo/logs/ckpool.log
```

---

## Realistic expectations

| Hardware | Hashrate | Avg. time to find a block* |
|----------|----------|---------------------------|
| 1× S9 | ~14 TH/s | ~28 years |
| 2× S9 | ~28 TH/s | ~14 years |
| 1× S19 Pro | ~110 TH/s | ~3.5 years |
| 1× S21 | ~200 TH/s | ~2 years |

*At current network difficulty (~140 EH/s). Expected value — actual results follow a geometric distribution, meaning you could find a block tomorrow or never. Most solo miners view this as a low-cost lottery ticket backed by hardware they already own.

---

## Building the image yourself

If you prefer to build from source rather than use the pre-built image:

```bash
docker build -t bitcryptic/ckpool-solo:latest .
```

---

## Credits

- [ckpool](https://bitbucket.org/ckolivas/ckpool) by Con Kolivas (ckolivas)
- Unraid template by [BitCryptic](https://bitcryptic.com)
