# ckpool-solo — Unraid Template

Unraid Community Applications template for running **ckpool-solo** — a self-hosted Bitcoin solo mining stratum server — via the `bitcryptic/ckpool-solo` Docker image.

Built from the official [ckpool-solo source](https://bitbucket.org/ckolivas/ckpool-solo) by Con Kolivas, compiled on Debian Bookworm Slim for `linux/amd64`.

## Quick Install

Add this repository to Unraid Community Applications:

`https://raw.githubusercontent.com/bitcryptic-gw/unraid-ckpool-solo/main/ckpool-solo.xml`

Drop the XML directly into `/boot/config/plugins/dockerMan/templates-user/` on your Unraid server, or wait for CA listing.

## Requirements

- Fully synced Bitcoin Core node with RPC enabled
- `ckpool.conf` configured with your node's RPC credentials and your Bitcoin address
- Miners pointed at `stratum+tcp://unraid-ip:3333`

## Template Variables

| Variable | Description | Required |
|---|---|---|
| AppData path | Host path for config and logs | Yes |
| Stratum port | Default 3333 | Yes |

## ckpool.conf Example

See `config/ckpool.conf.example` in this repo for a minimal working configuration.

Key fields:
- `btcd.url` — Bitcoin Core RPC endpoint (e.g. `10.61.21.4:8332`)
- `btcd.auth` / `btcd.pass` — RPC credentials (use `rpcauth` in `bitcoin.conf`)
- `btcaddress` — your Bitcoin address for block rewards
- `logdir` — set to `/var/log/ckpool` (maps to your AppData logs path)

## Network Note

This template uses the `fixedips` Docker network by default, assigning a static IP (`10.61.21.5`) on the same subnet as Bitcoin Core. Adjust to match your own network setup.

## Notes

- The `-k` flag is used to kill stale PID files on startup, preventing stuck-container issues after unclean shutdowns
- Exclude this container from Unraid's Appdata Backup plugin to prevent SIGTERM restarts during backup
- Container runs as root (required for log directory creation)

## Links

- [Docker Hub](https://hub.docker.com/r/bitcryptic/ckpool-solo)
- [Unraid forum support thread](https://forums.unraid.net/topic/XXXXX) ← update at go-live
- [ckpool upstream (Bitbucket)](https://bitbucket.org/ckolivas/ckpool-solo)
- [BitCryptic](https://bitcryptic.com)
