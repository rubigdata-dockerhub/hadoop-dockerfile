# Apache Zeppelin 4 RUBigData

## Setup

Checkout Zeppelin branch:

    git clone -b zeppelin \
      git@github.com:rubigdata-dockerhub/hadoop-dockerfile.git \
      hadoop-dockerfile-zeppelin
    cd hadoop-dockerfile-zeppelin

## Trimming Zeppelin

__Optional.__

Initialize Dockerfile setup from official repo:

    curl -so log4j.properties https://raw.githubusercontent.com/apache/zeppelin/c46c3d7efc27477ccde53893b0ef0c394f6fe44d/scripts/docker/zeppelin/bin/log4j.properties
    curl -so Dockerfile https://raw.githubusercontent.com/apache/zeppelin/c46c3d7efc27477ccde53893b0ef0c394f6fe44d/scripts/docker/zeppelin/bin/Dockerfile

Adapt Dockerfile to use netinst version:

    TODO: some fancy patch    

Add course specific instructions:

    TODO: some fancy patch    

## Zeppelin

Create image:

    cd gh/hadoop-dockerfile-zeppelin/
    docker build -t hadoop:devel .

Create container:

    docker create --name snbz -p 9001:8080 -p 4040-4045:4040-4045 hadoop:devel
    docker start snbz
   
What's going on:

    docker logs snbz

Start the stream:

    docker cp stream.py snbz:/
    docker exec snbz sh -c "python stream.py &"

## Ballon

    docker build -t "docker.io/rubigdata/ballon:v0.9.0" --format docker --no-cache .
    docker create --name snbz -p 9001:8080 -p 4040-4045:4040-4045 ballon:v0.9.0
    docker start snbz

    docker logs snbz

    docker cp stream.py snbz:/
    docker exec snbz sh -c "python3 stream.py &"

    docker exec -it snbz /bin/bash

## Project

    docker build -t "docker.io/rubigdata/project:v0.9.1" --format docker --no-cache .
    docker create --name cc -p 9001:8080 -p 4040-4045:4040-4045 project:v0.9.1
    docker start cc
    docker exec -it cc /bin/bash

    wget -r -l 3 "http://rubigdata.github.io/course/" --warc-file="course"
    docker exec -it cc mkdir -p /data
    docker cp course.warc.gz cc:/data
    docker exec -it cc /bin/bash 

