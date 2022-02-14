#!/bin/bash

if [ "$(ls -A "$NAMEDIR")" == "" ]; then
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
  hadoop fs -mkdir -p    /user/hive/warehouse
  hadoop fs -chmod g+w   /user/hive/warehouse
  schematool -dbType postgres -initSchema
  touch "$NAMEDIR/initialized"
fi

echo "Starting Hive Metastore..."
hive --service metastore &

echo "Starting Hive server2..."
hiveserver2