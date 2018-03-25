FROM alpine

ARG REPO=bitly/oauth2_proxy
ARG VERSION=2.2.0
ARG BASE_NAME=oauth2_proxy-$VERSION.linux-amd64.go1.8.1
ARG GITHUB_TOKEN=

ADD Makefile /

RUN set -ex \
    && apk update \
    && apk add ca-certificates 

RUN set -ex \
    && apk update \
    && apk add --no-cache --virtual .build-deps \
        bash \
        curl \
        git \
        make \
        jq \
    && make init \
    && make github/download-public-release \
        FILE=$BASE_NAME.tar.gz \
        OUTPUT=oauth2-proxy.tar.gz \
        VERSION=v$VERSION \
    && tar -zxvf oauth2-proxy.tar.gz \
    && rm -f oauth2-proxy.tar.gz \
    && mv $BASE_NAME/oauth2_proxy /bin/ \
    && chmod +x /bin/oauth2_proxy \
    && rm -rf $BASE_NAME* \
    && make clean \
    && rm -f /Makefile \
    && apk del .build-deps

EXPOSE 4180 443

ENTRYPOINT ["/bin/oauth2_proxy"]
