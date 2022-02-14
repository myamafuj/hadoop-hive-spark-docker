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
mapred historyserver