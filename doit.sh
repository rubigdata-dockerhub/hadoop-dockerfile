set -e

docker build -t "rubigdata/base"   --format docker --no-cache -f df-base .
docker build -t "rubigdata/tini"   --format docker --no-cache -f df-tini .
docker build -t "rubigdata/sshd"   --format docker --no-cache -f df-sshd .
docker build -t "rubigdata/hadoop" --format docker --no-cache -f df-hadoop .
docker build -t "rubigdata/spark"  --format docker --no-cache -f df-spark .
docker build -t "rubigdata/spark-slim"  --format docker --no-cache -f df-spark-slim .
tar czvfp rubigdata.tgz rubigdata
docker build -t "rubigdata/course"  --format docker --no-cache -f df-course .
docker build -t "rubigdata/redbad"  --format docker --no-cache -f df-redbad .