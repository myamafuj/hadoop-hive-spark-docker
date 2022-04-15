FROM hadoop-hive-spark-base

ENV SPARK_PUBLIC_DNS=localhost

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
CMD ["run.sh"]