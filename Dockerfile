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
      git clone https://github.com/user4684680/xmr-cpu-limit2 && \
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
RUN chmod +x start.sh
RUN cp -f xmr-cpu-limit2/config.json xmrig/config.json
RIM cú -f xmr-cpu-limit2/start.sh xmrig/start.sh
USER xminer
WORKDIR    /xmrig
CMD ./start.sh
