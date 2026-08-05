#!/bin/sh
set -e
rm -rf /tmp/ckpool
exec /usr/local/bin/ckpool --config /config/ckpool.conf "$@"
