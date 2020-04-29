# Hadoop plus Spark Notebook Dockerfile

Dockerfile that extends Spark Notebook with the necessary packages for running Hadoop in assignment 2 of the RU Big Data course.
See also [rubigdata.github.io](https://rubigdata.github.io).

## Setup

For Spark Notebook information, see:

+ [`spark-notebook.io`](https://spark-notebook.io)
+ Readily available [Spark Notebook versions](https://hub.docker.com/r/andypetrella/spark-notebook/tags/)
+ More version information: [Spark notebook releases](https://github.com/spark-notebook/spark-notebook/blob/master/docs/using_releases.md)

Match up the `Dockerfile`, Spark Notebook and [corresponding Hadoop version](http://ftp.nluug.nl/internet/apache/hadoop/common/)
from the mirror we use (or update to an alternative one).

## Pushing to Docker hub

[Docker hub](https://hub.docker.com) can be used to distribute the image. Login to Docker Hub using the native command `docker login`. Once logged in, you can push an existing image using `docker push [OPTIONS] NAME[:TAG]`. 

## Spark-Notebook

The project has been abandoned, the original website does not exist any more.
We may need to switch to Zeppelin.

Or revive the build process:
https://github.com/spark-notebook/spark-notebook/blob/master/docs/build_from_source.md


