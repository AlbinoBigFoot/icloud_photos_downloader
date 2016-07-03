#!/usr/local/bin/dumb-init /bin/sh

# This command will quit if there are already iCloud credentials.
# If there are no credentials, then use an interactive docker session to set them.
icloud --username=${APPLE_ID_USERNAME}

# Download all photos and videos from iCloud
./icloud_photos_downloader/download_photos.py --username=${APPLE_ID_USERNAME} --size=original --download-videos /photos
