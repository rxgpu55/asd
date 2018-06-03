FROM  alpine:latest
RUN   adduser -S -D -H -h /xmrig xminer
RUN   apk --no-cache upgrade && \
      apk --no-cache add \
        cpulimit \
        wget \
        git \
        cmake \
        libuv-dev \
        build-base && \
      cd / && \
      git clone https://github.com/xmrig/xmrig && \
      cd xmrig && \
      sed -i -e 's/constexpr const int kDonateLevel = 1;/constexpr const int kDonateLevel = 0;/g' src/donate.h && \
      mkdir build && \
      cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF . && \
      make && \
      apk del \
        build-base \
        cmake \
        git
RUN apk add --no-cache --virtual .bootstrap-deps wget ca-certificates \
    && <do the bootstrap script thingy here> \
    && apk del .bootstrap-deps
USER xminer
WORKDIR    /xmrig
RUN wget https://github.com/user4684680/xmr-cpu-limit2/releases/download/1/config.json
ENTRYPOINT   ["./xmrig", "cpulimit -e xmrig -l 50 -b"]
