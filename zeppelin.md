# Apache Zeppelin 4 RUBigData

## Setup

Checkout Zeppelin branch:

    git clone -b zeppelin \
	  git@github.com:rubigdata-dockerhub/hadoop-dockerfile.git \
	  hadoop-dockerfile-zeppelin

	cd hadoop-dockerfile-zeppelin

Create image:

    cd gh/hadoop-dockerfile-zeppelin/
	IH=$(docker build .)
	docker tag $IH hadoop:devel

Create container:

	docker create --name snbz -p 9001:8080 -p 4040-4045:4040-4045 hadoop:devel
	docker start snbz
   
What's going on:

	docker logs snbz

Start the stream:

    docker cp stream.py snbz:/
	docker exec snbz sh -c "python stream.py &"
	
