#!/bin/bash

if [ "$(ls -A "$NAMEDIR")" == "" ]; then
  echo "Formatting namenode name directory: $NAMEDIR"
  hdfs namenode -format
fi

echo "Starting Hadoop name node..."
hdfs namenode