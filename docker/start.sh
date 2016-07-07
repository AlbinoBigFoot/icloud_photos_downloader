#!/usr/local/bin/dumb-init /bin/sh

# adapted from http://stackoverflow.com/a/28596874
# Get UID/GID of the target directory
TARGET_UID=$(stat -c "%u" /photos)
TARGET_GID=$(stat -c "%g" /photos)
echo "Matching target photos volume UID/GID: $TARGET_UID / $TARGET_GID"

# username / home directory
USERNAME="tempuser" #Username doesn't really matter, its the UID/GID that matters
HOMEDIR="/home/$USERNAME"

# Create the user with the given UID
adduser -D -H -u ${TARGET_UID} $USERNAME
GROUP="tempuser" # adduser creates a group by the same name

# This path is untested, because the UID/GID are usually the same
if [ $TARGET_UID != $TARGET_GID ]; then
	# Check to see if there is already a group with the needed GID
	EXISTS=$(cat /etc/group | grep ":$TARGET_GID:" | wc -l)

	if [ $EXISTS == "0" ]; then
		# Group does not exist, so we'll need to create it
		GROUP="tempgroup" # Create a new group by a different name
		echo "Creating group with GID=$TARGET_GID: $GROUP"
		addgroup -g $TARGET_GID $GROUP
	else
		# GID exists, find group name and add
    	GROUP=$(getent group $TARGET_GID | cut -d: -f1)
    	echo "Group $TARGET_GID already exists: $GROUP"
	fi

	# Add user to group
	echo "add user $USERNAME to group $GROUP"
	addgroup $USERNAME $GROUP
fi

# Create home directory if needed. The plaintext keyring will be stored here
if [ ! -d "$HOMEDIR" ]; then
	echo "Creating home directory: $HOMEDIR"
	mkdir -p $HOMEDIR
	chown $USERNAME:$GROUP $HOMEDIR
	chmod -R a-rwx,u+rwx $HOMEDIR
fi

# This command will quit if there are already iCloud credentials.
# If there are no credentials, then use an interactive docker session to set them.
# run as the USER/GROUP as to make sure the keychain is placed in the right place.
gosu $USERNAME:$GROUP icloud --username=${APPLE_ID_USERNAME}

# Download all photos and videos from iCloud
# run as the USER/GROUP as to make sure the files have the right owner/group
gosu $USERNAME:$GROUP ./icloud_photos_downloader/download_photos.py --username=${APPLE_ID_USERNAME} --size=original --download-videos /photos
