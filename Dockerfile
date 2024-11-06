FROM ubuntu:18.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive
ENV BDB_PREFIX="/usr/local"
ENV LD_LIBRARY_PATH="/usr/local/lib"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git make g++ wget autoconf automake libtool \
    libevent-dev pkg-config libboost-all-dev \
    libssl-dev ca-certificates bsdmainutils && \
    addgroup --gid 1000 bolivar && \
    adduser --disabled-password --gecos "" --home /bolivar --ingroup bolivar --uid 1000 bolivar && \
    mkdir -p /bolivar/.Bolivarcoin && \
    chown -R bolivar:bolivar /bolivar/.Bolivarcoin && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bolivar
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    cd db-4.8.30.NC/build_unix && \
    wget -O ../dist/config.guess https://git.savannah.gnu.org/cgit/config.git/plain/config.guess && \
    wget -O ../dist/config.sub https://git.savannah.gnu.org/cgit/config.git/plain/config.sub && \
    ../dist/configure --prefix=$BDB_PREFIX --enable-cxx && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf db-4.8.30.NC db-4.8.30.NC.tar.gz


RUN git clone https://github.com/BOLI-Project/BolivarCoin.git /bolivar/BolivarCoin && \
    cd /bolivar/BolivarCoin && \
    git checkout tags/v2.0.0.2 && \
    ./autogen.sh && \
    ./configure --without-gui --with-bdb=$BDB_PREFIX && \
    make -j$(nproc)

RUN mkdir -p /output && \
    cp /usr/local/lib/libdb_cxx-4.8.so /output/ && \
    cp /bolivar/BolivarCoin/src/bolivarcoind /output/

FROM ubuntu:18.04
ENV LD_LIBRARY_PATH="/usr/local/lib"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libevent-dev libboost-all-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /output/libdb_cxx-4.8.so /usr/local/lib/
COPY --from=builder /output/bolivarcoind /usr/local/bin/

RUN addgroup --gid 1000 bolivar && \
    adduser --disabled-password --gecos "" --home /bolivar --ingroup bolivar --uid 1000 bolivar && \
    mkdir -p /bolivar/.Bolivarcoin && \
    chown -R bolivar:bolivar /bolivar/.Bolivarcoin
USER bolivar
VOLUME /bolivar/.Bolivarcoin

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]


# P2P
EXPOSE 3893/tcp
# RPC
EXPOSE 3563/tcp
