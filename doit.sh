docker build -t "rubigdata/base" --format docker --no-cache -f df-base .
docker build -t "rubigdata/tini" --format docker --no-cache -f df-tini .
docker build -t "rubigdata/sshd" --format docker --no-cache -f df-ssh .
docker build -t "rubigdata/hadoop" --format docker --no-cache -f df-hadoop .