# Use an official Python runtime as a parent image
FROM andypetrella/spark-notebook:0.9.0-SNAPSHOT-scala-2.11.8-spark-2.3.2-hadoop-2.9.2-with-hive

# Make ports 9000 and 4040-4045 available to the world outside this container
EXPOSE 9000 4040-4045

RUN \
  apt-get update && \
  apt-get install -y wget less nano rsync ssh && \
  wget -q http://ftp.nluug.nl/internet/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz && \
  tar xzfp hadoop-2.9.2.tar.gz

ADD core-site.xml hdfs-site.xml hadoop-2.9.2/etc/hadoop/

RUN \ 
  echo export JAVA_HOME=${JAVA_HOME} >> ${HOME}/.bashrc && \
  export TERM=xterm && \
  ssh-keygen -t rsa -P '' -f ${HOME}/.ssh/id_rsa && \
  cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys && \
  chmod 0600 ${HOME}/.ssh/authorized_keys && \
  echo export PATH=$PATH:/opt/docker/hadoop-2.9.2/bin:/opt/docker/hadoop-2.9.2/sbin >> ${HOME}/.bashrc  

ENTRYPOINT service ssh start && bin/spark-notebook -Dpidfile.path=/dev/null
