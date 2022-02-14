FROM hadoop-hive-spark-base

ENV NAMEDIR=/dfs/name
RUN mkdir -p /dfs/name
VOLUME /dfs/name

COPY run.sh /usr/local/sbin/run.sh
RUN chmod a+x /usr/local/sbin/run.sh

ENV SPARK_PUBLIC_DNS=localhost
ENV SPARK_LOGS_HDFS_PATH=/var/log/spark
ENV SPARK_JARS_HDFS_PATH=/spark/jars

CMD ["run.sh"]