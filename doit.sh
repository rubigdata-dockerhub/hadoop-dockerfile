set -e

export DHUB_CREDS=arjenpdevries:882be18f-cda1-42f5-b824-3b9c87f3e3a0

echo Create base
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/base:buildx-new \
	--jobs 4 --secret=id=rubigdatapass,src=fpass --format docker --no-cache -f df-base .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/base:buildx-new docker.io/rubigdata/base:buildx-latest

echo Create ssh daemon base
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/sshd:buildx-new \
	--jobs 4 --format docker --no-cache -f df-sshd .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/sshd:buildx-new docker.io/rubigdata/sshd:buildx-latest

echo Create Hadoop base
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/hadoop:buildx-new \
	--jobs 4 --secret=id=rubigdatapass,src=fpass --format docker --no-cache -f df-hadoop .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/hadoop:buildx-new docker.io/rubigdata/hadoop:buildx-latest

echo Create Spark base
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/spark:buildx-new \
	--jobs 4 --format docker --no-cache -f df-spark .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/spark:buildx-new docker.io/rubigdata/spark:buildx-latest

echo Create smaller Spark base \(no Hadoop\)
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/spark-slim:buildx-new \
	--jobs 4 --secret=id=rubigdatapass,src=fpass --format docker --no-cache -f df-spark-slim .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/spark-slim:buildx-new docker.io/rubigdata/spark-slim:buildx-latest

# Create course assignment data if necessary:
echo Course assignment specific data
[ ! -e rubigdata.tgz ] && tar czvfp rubigdata.tgz rubigdata

# build course image:
echo Create course image
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/course:buildx-new \
	--jobs 4 --format docker --no-cache -f df-course .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/course:buildx-new docker.io/rubigdata/course:new

echo Create image for access to redbad
podman buildx build --platform=linux/amd64,linux/arm64/v8 --manifest localhost/rubigdata/redbad:buildx-new \
	--jobs 4 --format docker --no-cache -f df-redbad .
podman manifest push --creds $DHUB_CREDS localhost/rubigdata/redbad:buildx-new docker.io/rubigdata/redbad:new

