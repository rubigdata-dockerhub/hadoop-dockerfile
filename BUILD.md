# Building the Dockerfile

## Multi-stage build

We use a [multi-stage build][msb] setup to simplify debugging and
reduce build time when we need to make changes to an intermediate
level.

### Password

We want to enable users of the containers to become root so they can
install new software. This uses a `secret` initialized as follows:

    echo mypassword > fpass

The password is provided to `podman build` using the `--secret` flag as follows:

    --secret=id=rubigdatapass,src=fpass

### Base

The `base` image takes care of base utilities and environment
variables that we need.

	docker build -t "rubigdata/base" --format docker --no-cache -f df-base .

We then install `tini` in a second image that extends `rubigdata/base`:

	docker build -t "rubigdata/tini" --format docker --no-cache -f df-tini .

We use this `tini` image only in a multi-stage setup, by copying the
installed `tini` version into the next level. To illustrate, consider
the `df-shell` [Dockerfile](df-shell), that installs the `tini`
prepared in the previous step over `base` and adds no more than a
`bash` shell (using a `COPY --from rubigdata/base:latest` command):

    docker build -t "test" --format docker --no-cache -f df-shell .
	
Metadata about the image:

    docker inspect test | jq ".[0].Config.Labels"

You can take a test-drive using `docker run --rm -it test`.

### Hadoop

We would have installed Hadoop at the second level, wouldn't we _also_
need `sshd` to run a pseudo-distributed cluster, and Red Hat UBI not
providing an openssh-server package (yet?).

So, we have created an image that includes `sshd` build from source,
in a multi-stage build:

    docker build -t "rubigdata/sshd" --format docker --no-cache -f df-sshd .

We then install Hadoop on top of that, using the `df-hadoop` [Dockerfile](df-hadoop).

    docker build -t "rubigdata/hadoop" --format docker --no-cache -f df-hadoop .

### Spark

Third level installs `spark` using the "hadoop provided" pre-compiled release,
setting configuration info (e.g. `SPARK_DIST_CLASSPATH`) following the 
[documentation](https://spark.apache.org/docs/latest/hadoop-provided.html).


__TODO__

### Zeppelin

Fourth level installs `zeppelin`:

__TODO__


### Debugging

Copy-paste the part of the `Dockerfile` to be tested into `testing-dockerfile`.
Use `testing-dockerfile` as follows:

    docker build -f testing-dockerfile -t testje .
    docker run --rm -it testje

Once you have success:

    docker rmi testje

[msb]: https://docs.docker.com/develop/develop-images/multistage-build/ "Multistage-build documentation"
