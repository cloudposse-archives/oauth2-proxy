FROM alpine

ARG REPO=bitly/oauth2_proxy
ARG VERSION=2.1
ARG BASE_NAME=oauth2_proxy-$VERSION.linux-amd64.go1.6
ARG GITHUB_TOKEN=

ADD Makefile /

RUN set -ex \
    && apk update \
    && apk add --no-cache --virtual .build-deps \
            bash \
						curl \
						git \
						make \
						jq \
		&& make init \
		&& make \
		    FILE=$BASE_NAME.tar.gz \
		    OUTPUT=oauth2-proxy.tar.gz \
		    VERSION=v$VERSION \
		    github:download-release \
		&& tar -zxvf oauth2-proxy.tar.gz \
		&& rm -f oauth2-proxy.tar.gz \
		&& ls -l  \
		&& ls -l $BASE_NAME  \
		&& mv $BASE_NAME/oauth2_proxy /bin/ \
		&& chmod +x /bin/oauth2_proxy \
		&& rm -rf $BASE_NAME* \
    && make clean \
    && rm -f /Makefile \
    && ls -l / \
    && apk del .build-deps

EXPOSE 80 443

ENTRYPOINT ["/bin/oauth2_proxy"]