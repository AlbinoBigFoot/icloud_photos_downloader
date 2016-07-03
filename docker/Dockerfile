FROM alpine:latest
MAINTAINER Jake Bordens <jake@allaboutjake.com>

VOLUME /photos
VOLUME /root

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