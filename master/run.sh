#!/bin/bash

if [ -z "$(ls -A "$NAMEDIR")" ]; then
  echo "Formatting namenode name directory: $NAMEDIR"
  hdfs namenode -format
fi

echo "Starting Hadoop name node..."
hdfs --daemon start namenode

echo "Starting Hadoop secondary name node..."
hdfs --daemon start secondarynamenode

echo "Starting Hadoop resource manager..."
yarn --daemon start resourcemanager

echo "Starting Hadoop history server..."
mapred --daemon start historyserver

if [ ! -f "$NAMEDIR/initialized" ]; then
  echo "Configuring Hive..."
  hadoop fs -mkdir -p  /user/hive/warehouse
  hadoop fs -chmod 755 /user/hive/warehouse
  schematool -dbType postgres -initSchema
  touch "$NAMEDIR/initialized"
fi

echo "Starting Hive Metastore..."
hive --service metastore &

echo "Starting Hive server2..."
hiveserver2 &

echo "Starting Spark master node..."
if ! hadoop fs -test -d "${SPARK_LOGS_HDFS_PATH}"
then
  hadoop fs -mkdir -p  "${SPARK_LOGS_HDFS_PATH}"
  hadoop fs -chmod 777 "${SPARK_LOGS_HDFS_PATH}"
fi
if ! hadoop fs -test -d "${SPARK_JARS_HDFS_PATH}"
then
  hadoop fs -mkdir -p  "${SPARK_JARS_HDFS_PATH}"
  hadoop fs -chmod 755 "${SPARK_JARS_HDFS_PATH}"
  hdfs dfs -copyFromLocal "${SPARK_HOME}/jars" "${SPARK_JARS_HDFS_PATH}/.."
fi

start-history-server.sh
spark-class "org.apache.spark.deploy.master.Master"