FROM ubuntu:latest

RUN sed -i.bak -e "s/http:\/\/archive\.ubuntu\.com/http:\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list \
 && apt-get update  \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      curl \
      gnupg \
      procps \
 && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Hadoop
RUN curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o /tmp/KEYS  \
 && gpg --import /tmp/KEYS

ENV HADOOP_VERSION=3.2.2
ENV HADOOP_URL=https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HADOOP_HOME=/opt/hadoop

RUN set -x \
 && mkdir $HADOOP_HOME \
 && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
 && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
 && gpg --verify /tmp/hadoop.tar.gz.asc \
 && tar -xvf /tmp/hadoop.tar.gz -C $HADOOP_HOME --strip-components 1 \
 && rm /tmp/hadoop.tar.gz* \
 && mkdir $HADOOP_HOME/logs

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH

COPY conf/core-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/hdfs-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/yarn-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/mapred-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/workers "${HADOOP_CONF_DIR}/"

# Hive
RUN curl -fSL https://dist.apache.org/repos/dist/release/hive/KEYS -o /tmp/KEYS  \
 && gpg --import /tmp/KEYS

ENV HIVE_VERSION=3.1.2
ENV HIVE_URL=https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
ENV HIVE_HOME=/opt/hive
ENV JDBC_URL=https://jdbc.postgresql.org/download/postgresql-42.3.2.jar

RUN set -x \
 && mkdir $HIVE_HOME \
 && curl -fSL "$HIVE_URL" -o /tmp/hive.tar.gz \
 && curl -fSL "$HIVE_URL.asc" -o /tmp/hive.tar.gz.asc \
 && gpg --verify /tmp/hive.tar.gz.asc \
 && tar -xvf /tmp/hive.tar.gz -C $HIVE_HOME --strip-components 1 \
 && rm /tmp/hive.tar.gz*

RUN set -x \
 && rm $HIVE_HOME/lib/guava-* \
 && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-* $HIVE_HOME/lib/

ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH=$HIVE_HOME/sbin:$HIVE_HOME/bin:$PATH

COPY conf/hive-site.xml "${HIVE_CONF_DIR}/"

# Entry point
ENV USER=root
COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
RUN chmod a+x /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]