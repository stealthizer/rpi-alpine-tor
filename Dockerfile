# Tor 0.3.3.7 - stable version

FROM armhf/alpine:latest
MAINTAINER dockernaut.wordpress.com

EXPOSE 9050

RUN build_pkgs=" \
    openssl-dev \
    zlib-dev \
    libevent-dev \
    gnupg \
    " \
  && runtime_pkgs=" \
    build-base \
    openssl \
    zlib \
    libevent \
    " \
  && apk --update add ${build_pkgs} ${runtime_pkgs} \
  && cd /tmp \
  && wget https://dist.torproject.org/tor-0.3.3.7.tar.gz \
  && wget https://dist.torproject.org/tor-0.3.3.7.tar.gz.asc \
  && gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 0x6AFEE6D49E92B601 \
  && gpg --verify tor-0.3.3.7.tar.gz.asc \
  && tar xzf https://dist.torproject.org/tor-0.3.3.7.tar.gz \
  && cd /tmp/tor-0.3.3.7 \
  && ./configure \
  && make -j6 \
  && make install \
  && cd \
  && rm -rf /tmp/* \
  && apk del ${build_pkgs} \
  && rm -rf /var/cache/apk/*

RUN adduser -Ds /bin/sh tor

RUN mkdir /etc/tor
COPY torrc /etc/tor/

USER tor
CMD ["tor", "-f", "/etc/tor/torrc"]
