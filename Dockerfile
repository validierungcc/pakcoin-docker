FROM alpine:3.19 as builder

RUN apk add --no-cache git make g++ boost-dev openssl-dev db-dev miniupnpc-dev zlib-dev
RUN addgroup --gid 1000 emark
RUN adduser --disabled-password --gecos "" --home /emark --ingroup emark --uid 1000 emark

USER emark

RUN git clone https://github.com/emarkproject/eMark.git /emark/eMark
WORKDIR /emark/eMark
RUN git checkout tags/2.1.0
WORKDIR /emark/eMark/src
RUN make -f makefile.unix

FROM alpine:3.19

RUN apk add --no-cache boost-dev db-dev miniupnpc-dev zlib-dev bash curl
RUN addgroup --gid 1000 emark
RUN adduser --disabled-password --gecos "" --home /emark --ingroup emark --uid 1000 emark

USER emark
COPY --from=builder /emark /emark
COPY ./entrypoint.sh /

RUN mkdir /emark/.eMark-volume-2
VOLUME /emark/.eMark-volume-2
ENTRYPOINT ["/entrypoint.sh"]

# P2P
EXPOSE 4555/tcp
# RPC
EXPOSE 4444/tcp
# Testnet P2P
EXPOSE 14555/tcp
# Testnet RPC
EXPOSE 14444/tcp
