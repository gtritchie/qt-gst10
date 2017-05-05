# qt-gst10

Docker configuration for building Qt from source.

First, build the docker image. This will build Qt from source inside the image with all the appropriate flags.

    docker build t "qt-gst10:builder" -f Dockerfile.x86_64 .

Next, copy the tarball from the built image:

    id=$(docker create qt-gst10:builder)
    docker cp $id:/qt/QtSDK-5.4.2-x86_64.tar.gz .
    docker rm -v $id

Finally, push that up to S3:

    aws s3 cp QtSDK-5.4.2-x86_64.tar.gz s3://rstudio-buildtools/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

## Tips on Configuring

Modules that don't have their prerequisites present will simply not build. If your resultant tarball is missing some Qt modules, you need to figure out what prereqs were missing.

`QtWebKit` is the neediest Qt module, but was also the primary motivation for setting up this repo. If you find that it's missing, open a shell against the failed image and run the following command inside the `qtwebkit` module directory (you'll find it beneath `/qt/qt-everywhere/opensource/...`):

    make reconfigure

This will perform the dependency scan again and tell you why the module is not building.

Most modules will also have a `config.log` at their root level, which shows a human-readable overview of their compilation configuration.

