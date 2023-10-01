FROM alpine:3.18.2 as builder

RUN apk add --no-cache git make g++ boost-dev openssl-dev db-dev miniupnpc-dev zlib-dev
RUN addgroup --gid 1000 emark
RUN adduser --disabled-password --gecos "" --home /emark --ingroup emark --uid 1000 emark

USER emark

RUN git clone https://github.com/emarkproject/eMark.git /emark/eMark
WORKDIR /emark/eMark
RUN git checkout tags/2.1.0
WORKDIR /emark/eMark/src
RUN make -f makefile.unix

FROM alpine:3.18.2

RUN apk add --no-cache boost-dev db-dev miniupnpc-dev zlib-dev bash curl
RUN addgroup --gid 1000 emark
RUN adduser --disabled-password --gecos "" --home /emark --ingroup emark --uid 1000 emark

USER emark
COPY --from=builder /emark /emark
COPY ./entrypoint.sh /

RUN mkdir /emark/.eMark-volume-2
VOLUME /emark/.eMark-volume-2
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 4555/tcp
EXPOSE 4444/tcp
EXPOSE 14555/tcp
EXPOSE 14444/tcp
