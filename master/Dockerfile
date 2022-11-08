FROM hadoop-hive-spark-base

ENV NAMEDIR=/opt/hadoop/dfs/name
RUN mkdir -p /opt/hadoop/dfs/name
VOLUME /opt/hadoop/dfs/name

#ENV NAMESECONDDIR=/opt/hadoop/dfs/namesecondary
#RUN mkdir -p /opt/hadoop/dfs/namesecondary
#VOLUME /opt/hadoop/dfs/namesecondary

ENV SPARK_PUBLIC_DNS=localhost
ENV SPARK_LOGS_HDFS_PATH=/var/log/spark
ENV SPARK_JARS_HDFS_PATH=/spark/jars

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
CMD ["run.sh"]