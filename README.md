# Zeppelin plus Hadoop Dockerfile

Dockerfile(s) for the assignments of the [RU Big Data course](https://rubigdata.github.io).

More details in [`zeppelin.md`](zeppelin.md) in this directory.

## Using Hadoop

Create a container with ports 9870 and 8088 exposed:

    docker create --name hello-hadoop -p 9870:9870 -p 8088:8088 -it rubigdata/course:a2

Start the container and attach a terminal:

    docker start hello-hadoop
    docker attach hello-hadoop

Open [localhost:9870](http://localhost:9870) for the web interface of
the NameNode, and [localhost:8088](http://localhost:8088) for the web
interface of the Yarn resource manager.

Done:

    docker stop hello-hadoop

## Building the images

See [BUILD.md](BUILD.md).

