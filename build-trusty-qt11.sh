#!/usr/bin/env bash

docker build -t "qt-trusty-11:builder" -f Dockerfile.trusty-x86_64-qt11 .
#id=$(docker create qt-trusty-11:builder)
#docker cp $id:/qt/QtSDK-5.11.1-trusty-x86_64.tar.gz .
#docker rm -v $id
#aws s3 cp QtSDK-5.11.1-trusty-x86_64.tar.gz s3://rstudio-buildtools/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

