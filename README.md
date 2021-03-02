# Zeppelin plus Hadoop Dockerfile

Dockerfile(s) for the assignments of the [RU Big Data course](https://rubigdata.github.io).

More details in [`zeppelin.md`](zeppelin.md) in this directory.

## Using Hadoop

Create a container with port 9870 exposed:

    docker create --name hadoop -p 9870:9870 -it rubigdata/hadoop

Start the container and attach a terminal:

    docker start hadoop
    docker attach hadoop

Open [localhost:9870](http://localhost:9870) for the web interface of the NameNode.

Done:

    docker stop hadoop

## Building the images

See [BUILD.md](BUILD.md).

