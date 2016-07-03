iCloud Photos Downloader - Docker image
---------------------------------------

icloud_photos_downloader tool packaged as a Docker image. Attmped to keep it small,
it comes to about ~76Mb.

See https://github.com/ndbroadbent/icloud_photos_downloader

This is my first Docker container, so don't expect too much.

Important disclosures
---------------------

I did not write the icloud_photos_downloader tool and do not specifically endorse it
as being secure or bug free.  Proceed at your own risk. 

Your credentials will be stored inside the Docker container using a PlainTextKeyring.  
This is probably not the most secure method, so proceed at your own risk.

How to use
----------

1.  Build the Docker image

From the directory that contains the Dockerfile:

    docker build -t icloud_photos_downloader .

This will download the icloud_photos_downloader from the original location
and install its dependencies.

2.  First launch

Launch the docker image with an interactive tty.  Make sure to edit the parameters,
mapping hte /photos folder inside the container to the folder on the host where you
want to store the images.  Edit the "APPLE_ID_USERNAME" parameter to your iCloud
user ID:

    docker run -it --net=host --name="iCloudPhotosDownloader" \
    	-v /volume1/photo/:/photos 
    	-e APPLE_ID_USERNAME=myfakeuserid12345@icloud.com
    	icloud_photos_downloader

This will launch the tool and provide you an interactive prompt to login to iCloud
and perform 2 factor authentication.

***NOTE***: your credentials will be stored inside the Docker container using
a PlainTextKeyring.  Probably not the most secure method, so proceed at your own risk

3.  Subsequent launches

Subsequent launches of the container can be done using "start"

    docker start iCloudPhotosDownloader

If you discard the container, then you'll have to reauthenticate like in Step 2.