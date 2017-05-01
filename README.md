# qt-gst10
Docker configuration for building Qt from source with gstreamer 1.0

First, build the docker image. This will build Qt from source inside the image with all the appropriate flags.

    docker build t "qt-gst10:builder" -f Dockerfile.x86_64 .

Next, copy the tarball from the built image:

    id=$(docker create qt-gst10:builder)
    docker cp $id:/qt/QtSDK-5.4.2-x86_64.tar.gz .
    docker rm -v $id

Finally, push that up to S3:

    aws s3 cp QtSDK-5.4.2-x86_64.tar.gz s3://rstudio-buildtools/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

