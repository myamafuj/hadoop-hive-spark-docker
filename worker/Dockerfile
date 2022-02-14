FROM hadoop-hive-spark-base

ENV DATADIR=/dfs/data
RUN mkdir -p /dfs/data
VOLUME /dfs/data

COPY run.sh /usr/local/sbin/run.sh
RUN chmod a+x /usr/local/sbin/run.sh

CMD ["run.sh"]