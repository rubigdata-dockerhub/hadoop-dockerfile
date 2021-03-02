# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3
MAINTAINER Arjen P. de Vries <arjen@acm.org>

ENV Z_VERSION="0.9.0"
ENV HADOOP_VER="3.2.2"
ENV SPARK_VER="3.0.2"
ENV SPARK_BIN_VER="3.0.2-bin-without-hadoop"

# Make sure we download:
# https://ftp.nluug.nl/internet/apache/spark/spark-3.0.2/spark-3.0.2-bin-hadoop3.2.tgz

ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    ZEPPELIN_ADDR="0.0.0.0"

RUN echo "$LOG_TAG install basic packages including tini" && \
    apk add --no-cache alpine alpine-doc \
      coreutils coreutils-doc \
      ncurses ncurses-doc \
      mandoc man-pages \
      bash bash-doc bash-completion \
      wget wget-doc curl curl-doc \
      grep grep-doc sed sed-doc \
      tini \
      procps nss openssl

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
RUN echo "$LOG_TAG Install java8" && \
    apk add --no-cache openjdk8

ENV PATH $PATH:$JAVA_HOME/bin

RUN echo "$LOG_TAG Install python related packages" && \
    apk add --no-cache python3 python3-dev py3-pip py3-numpy && \
    pip install -q pycodestyle==2.6.0 && \
    ln -sf /usr/bin/python3 /usr/bin/python

# prepare, maybe add a flag to compile for hadoop 3 here?
WORKDIR /
RUN echo "$LOG_TAG setting up spark" && \
  wget --quiet --show-progress http://ftp.nluug.nl/internet/apache/spark/spark-${SPARK_VER}/spark-${SPARK_BIN_VER}.tgz && \
  tar -xzf spark-${SPARK_BIN_VER}.tgz && \
  rm spark-${SPARK_BIN_VER}.tgz

#
# TODO: Can we remove more from the netinst?
# TODO: Check:     Do we have the interpreters we need?
#       Otherwise: https://zeppelin.apache.org/docs/0.9.0-preview1/usage/interpreter/installation.html
#
WORKDIR /
RUN echo "$LOG_TAG Download Zeppelin binary" && \
    wget --quiet --show-progress -O /tmp/zeppelin-${Z_VERSION}-bin-netinst.tgz https://ftp.nluug.nl/internet/apache/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-netinst.tgz && \
    tar -zxf /tmp/zeppelin-${Z_VERSION}-bin-netinst.tgz && \
    rm -rf /tmp/zeppelin-${Z_VERSION}-bin-netinst.tgz && \
    mkdir -p ${Z_HOME} && \
    mv /zeppelin-${Z_VERSION}-bin-netinst/* ${Z_HOME}/ && \
    chown -R root:root ${Z_HOME} && \
    mkdir -p ${Z_HOME}/logs ${Z_HOME}/run ${Z_HOME}/webapps && \
    # Allow process to edit /etc/passwd, to create a user entry for zeppelin
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    # Give access to some specific folders
    chmod -R 775 "${Z_HOME}/logs" "${Z_HOME}/run" "${Z_HOME}/notebook" "${Z_HOME}/conf" && \
    # Allow process to create new folders (e.g. webapps)
    chmod 775 ${Z_HOME}

COPY zeppelin-env.sh ${Z_HOME}/conf/
COPY log4j.properties ${Z_HOME}/conf/

USER 0

# Ports:
# Zeppelin (8080), hadoop (9870), spark (4040-4045)

EXPOSE 8080
EXPOSE 9870

EXPOSE 4040
EXPOSE 4041
EXPOSE 4042
EXPOSE 4043
EXPOSE 4044
EXPOSE 4045

#
# Course specific stuff follows - needs thorough check
#

RUN \
  apk add --no-cache \
    less less-doc \
    nano nano-doc \
    vim vim-doc vim-tutor \
    openssh openssh-doc \
    rsync rsync-doc \
    netcat-openbsd netcat-openbsd-doc && \
  cd / && \
  wget --quiet --show-progress http://ftp.nluug.nl/internet/apache/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz && \
  tar -xzf hadoop-${HADOOP_VER}.tar.gz && \
  rm -rf hadoop-${HADOOP_VER}.tar.gz && \
  bash -c 'echo export JAVA_HOME=${JAVA_HOME} >> /hadoop-${HADOOP_VER}/etc/hadoop/hadoop-env.sh' && \
  bash -c 'echo export HADOOP_HOME=/hadoop-${HADOOP_VER} >> /hadoop-${HADOOP_VER}/etc/hadoop/hadoop-env.sh' && \
  bash -c 'echo export HADOOP_CONF_DIR=/hadoop-${HADOOP_VER}/etc/hadoop >> /hadoop-${HADOOP_VER}/etc/hadoop/hadoop-env.sh' && \
  bash -c 'for ev in HDFS_NAMENODE HDFS_DATANODE HDFS_SECONDARYNAMENODE YARN_RESOURCEMANAGER YARN_NODEMANAGER ; \
   do \
     echo export ${ev}_USER=root ; \
   done >> /hadoop-${HADOOP_VER}/etc/hadoop/hadoop-env.sh'

ENV HADOOP_HOME /hadoop-${HADOOP_VER}
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV HADOOP_YARN_HOME $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ADD core-site.xml hdfs-site.xml /hadoop-${HADOOP_VER}/etc/hadoop/

RUN echo "$LOG_TAG initiate sshd at boot" && \
  mkdir -p /var/run/sshd && \
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
  echo "Welcome @ RUBigData 2021 Docker (SSH)" > /etc/motd && \
  sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config && \
  echo "root:rubigdata2021" | chpasswd && \
  ssh-keygen -t rsa -P '' -f ${HOME}/.ssh/id_rsa && \
  cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys && \
  chmod 0600 ${HOME}/.ssh/authorized_keys && \
  echo localhost $(cat /etc/ssh/ssh_host_rsa_key.pub) >> ${HOME}/.ssh/known_hosts && \
  echo 0.0.0.0 $(cat /etc/ssh/ssh_host_rsa_key.pub) >> ${HOME}/.ssh/known_hosts && \
  echo '[ ! -f /var/run/sshd.pid ] && /usr/sbin/sshd > /dev/null' >> ${HOME}/.bashrc && \
  echo export JAVA_HOME=${JAVA_HOME} >> ${HOME}/.bashrc && \
  echo . /hadoop-${HADOOP_VER}/etc/hadoop/hadoop-env.sh >> ${HOME}/.bashrc && \
  echo export SPARK_HOME=/spark-${SPARK_BIN_VER} >> ${HOME}/.bashrc && \
  echo export PATH=$PATH:/hadoop-${HADOOP_VER}/bin:/hadoop-${HADOOP_VER}/sbin >> ${HOME}/.bashrc

COPY interpreter.json /zeppelin/conf/interpreter.json

ENTRYPOINT [ "/sbin/tini", "--" ]

WORKDIR /
CMD ["/zeppelin/bin/zeppelin.sh"]
