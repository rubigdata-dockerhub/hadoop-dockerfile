#!/usr/bin/env bash
export SPARK_HOME=/opt/spark
export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)
export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
export YARN_CONF_DIR=/opt/hadoop/etc/hadoop
