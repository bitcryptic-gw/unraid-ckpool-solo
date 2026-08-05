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

- The image entrypoint (`docker-entrypoint.sh`) wipes `/tmp/ckpool` — runtime PID + IPC socket state only, never persistent data — on every container start. After an unclean shutdown (e.g. Docker's stop timeout SIGKILLs ckpool) a stale `/tmp/ckpool/main.pid` could otherwise block a restart, since the new container also runs as PID 1 and ckpool mistakes it for a live old instance. The wipe makes the container self-recovering on next start.
- ckpool handles SIGTERM gracefully (this is Docker's default stop signal), so no custom `STOPSIGNAL` is needed. The template sets `--stop-timeout=30` to give ckpool time to finish its shutdown path before Docker escalates to SIGKILL.
- Persistent data is only ever in your bind-mounted config and log paths (e.g. `/etc/ckpool` and `/var/log/ckpool`); the `/tmp/ckpool` wipe never touches them.
- Exclude this container from Unraid's Appdata Backup plugin to prevent SIGTERM restarts during backup
- Container runs as root (required for log directory creation)

## Links

- [Docker Hub](https://hub.docker.com/r/bitcryptic/ckpool-solo)
- [Unraid forum support thread](https://forums.unraid.net/topic/198377-support-ckpool-solo-self-hosted-bitcoin-solo-mining-for-unraid/)
- [ckpool upstream (Bitbucket)](https://bitbucket.org/ckolivas/ckpool-solo)
- [BitCryptic](https://bitcryptic.com)
