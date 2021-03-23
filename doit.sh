docker build -t "rubigdata/base"   --format docker --no-cache -f df-base .
docker build -t "rubigdata/tini"   --format docker --no-cache -f df-tini .
docker build -t "rubigdata/sshd"   --format docker --no-cache -f df-sshd .
docker build -t "rubigdata/hadoop" --format docker --no-cache -f df-hadoop .
docker build -t "rubigdata/spark"  --format docker --no-cache -f df-spark .
