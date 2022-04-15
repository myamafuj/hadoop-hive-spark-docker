#!/bin/bash

echo "Starting Hadoop data node..."
hdfs --daemon start datanode

echo "Starting Hadoop node manager..."
yarn --daemon start nodemanager

echo "Starting Spark slave node..."
spark-class org.apache.spark.deploy.worker.Worker "spark://master:7077"