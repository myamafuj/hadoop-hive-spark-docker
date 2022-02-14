FROM hadoop-hive-spark-base

ENV NAMEDIR=/dfs/name
RUN mkdir -p /dfs/name
VOLUME /dfs/name

COPY run.sh /usr/local/sbin/run.sh
RUN chmod a+x /usr/local/sbin/run.sh

CMD ["run.sh"]