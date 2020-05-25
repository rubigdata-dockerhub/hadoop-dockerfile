# Apache Zeppelin 4 RUBigData

## Setup

Checkout Zeppelin branch:

    git clone -b zeppelin \
      git@github.com:rubigdata-dockerhub/hadoop-dockerfile.git \
      hadoop-dockerfile-zeppelin
    cd hadoop-dockerfile-zeppelin

Initialize Dockerfile setup from official repo:

    curl -so log4j.properties https://raw.githubusercontent.com/apache/zeppelin/c46c3d7efc27477ccde53893b0ef0c394f6fe44d/scripts/docker/zeppelin/bin/log4j.properties
    curl -so Dockerfile https://raw.githubusercontent.com/apache/zeppelin/c46c3d7efc27477ccde53893b0ef0c394f6fe44d/scripts/docker/zeppelin/bin/Dockerfile

Adapt Dockerfile to use netinst version:

    

Add course specific instructions:

        

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
	
