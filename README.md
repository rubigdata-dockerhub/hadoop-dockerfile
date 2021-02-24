# Zeppelin plus Hadoop Dockerfile

Dockerfile that extends Apache Zeppelin with the necessary packages for running Hadoop in assignment 2 of the [RU Big Data course](https://rubigdata.github.io).

More details in [`zeppelin.md`](zeppelin.md) in this directory.

## Debugging

Copy-paste the part of the `Dockerfile` to be tested into `testing-dockerfile`.
Use `testing-dockerfile` as follows:

    docker build -f testing-dockerfile -t testje .
    docker run --rm -it testje

Once you have success:

    docker rmi testje
