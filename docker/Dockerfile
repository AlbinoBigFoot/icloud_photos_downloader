FROM alpine:latest
MAINTAINER Jake Bordens <jake at allaboutjake.com>

VOLUME /photos
VOLUME /root

ENV DUMB_INIT_VER=1.1.1

RUN apk update && apk upgrade && \
    apk add wget ca-certificates && \
    wget -qO /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VER}/dumb-init_${DUMB_INIT_VER}_amd64 && \
    chmod +x /usr/local/bin/dumb-init && \
    apk del wget && \
    rm -rf /var/cache/apk/*

# Install Python & Git
RUN apk add --update \
	git \
    python \
    py-pip \
    py-setuptools

# Get the icloud_photos_downloader
RUN git clone https://github.com/ndbroadbent/icloud_photos_downloader.git

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r icloud_photos_downloader/requirements.txt

# Don't need pip or git anymore
RUN apk del git py-pip

# Clean up 
RUN rm -rf /var/cache/apk/*

# Set the entrypoint
COPY start.sh .
RUN chmod +x start.sh
CMD ./start.sh