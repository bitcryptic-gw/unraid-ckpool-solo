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

RUN git clone https://bitbucket.org/ckolivas/ckpool.git /build/ckpool \
    && cd /build/ckpool \
    && autoreconf -fi \
    && ./configure \
    && make -j$(nproc) \
    && cp src/ckpool /usr/local/bin/ckpool \
    && rm -rf /build

RUN useradd -r -s /bin/false ckpool

USER ckpool

EXPOSE 3333

ENTRYPOINT ["/usr/local/bin/ckpool", "--config", "/config/ckpool.conf"]
