#!/bin/bash

echo "Starting Hadoop history server..."
mapred --daemon start historyserver

echo "Starting Spark history server..."
spark-class org.apache.spark.deploy.history.HistoryServer
