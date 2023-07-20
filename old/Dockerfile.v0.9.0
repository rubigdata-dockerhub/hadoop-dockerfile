# Use an official Python runtime as a parent image
FROM apache/zeppelin:0.9.0

USER 0

RUN \
  apt-get update -y && \
  apt-get dist-upgrade -y && \
  apt-get install -y wget less nano rsync ssh vim-athena netcat && \
  cd / && \
  wget http://ftp.nluug.nl/internet/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz && \
  tar xzfp hadoop-2.9.2.tar.gz && \
  rm -rf hadoop-2.9.2.tar.gz && \
  echo export JAVA_HOME=${JAVA_HOME} >> /hadoop-2.9.2/etc/hadoop/hadoop-env.sh

ADD core-site.xml hdfs-site.xml /hadoop-2.9.2/etc/hadoop/

RUN \ 
  echo export JAVA_HOME=${JAVA_HOME} >> ${HOME}/.bashrc && \
  export TERM=xterm && \
  ssh-keygen -t rsa -P '' -f ${HOME}/.ssh/id_rsa && \
  cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys && \
  chmod 0600 ${HOME}/.ssh/authorized_keys && \
  echo "service ssh start > /dev/null" >> ${HOME}/.bashrc && \
  echo export PATH=$PATH:/hadoop-2.9.2/bin:/hadoop-2.9.2/sbin >> ${HOME}/.bashrc

RUN \
  cd /zeppelin/lib && \
  wget https://jitpack.io/com/github/sara-nl/warcutils/8736afad41/warcutils-8736afad41.jar

COPY interpreter.json /zeppelin/conf/interpreter.json

ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR /
CMD ["/zeppelin/bin/zeppelin.sh"]

