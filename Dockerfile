FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libjansson-dev \
    libpthread-stubs0-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Pin to the v1.2.0 release tag. Upstream master (post-2026-07-31 SV2 merge)
# does not build without SV2 deps: check_listen_port_clashes() in ckpool.c is
# gated behind HAVE_SV2 but called unconditionally. v1.2.0 is the last tagged
# release before that refactor.
RUN git clone https://bitbucket.org/ckolivas/ckpool.git /build/ckpool \
    && cd /build/ckpool \
    && git checkout v1.2.0 \
    && autoreconf -fi \
    && ./configure \
    && make -j$(nproc) \
    && cp src/ckpool /usr/local/bin/ckpool \
    && rm -rf /build

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3333

# Wipes /tmp/ckpool (runtime PID + IPC socket state only) on every start so a
# stale PID file from an unclean shutdown can never block a fresh container
# start. Persistent data (/config, /logs) is bind-mounted and never touched.
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
