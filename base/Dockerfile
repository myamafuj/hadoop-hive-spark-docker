FROM ubuntu:latest

RUN sed -i.bak -e "s|http://archive.ubuntu.com|http://jp.archive.ubuntu.com|g" /etc/apt/sources.list \
 && apt-get update  \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      curl \
      gnupg \
      procps \
      python3 \
      python3-pip \
      python-is-python3 \
      coreutils \
      libc6-dev \
 && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Hadoop
RUN curl -fSL https://archive.apache.org/dist/hadoop/common/KEYS -o /tmp/KEYS  \
 && gpg --import /tmp/KEYS

ENV HADOOP_VERSION=3.2.2
#ENV HADOOP_URL="https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
ENV HADOOP_HOME=/opt/hadoop

RUN set -x \
 && mkdir ${HADOOP_HOME} \
 && curl -fSL "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" -o /tmp/hadoop.tar.gz \
 && curl -fSL "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" -o /tmp/hadoop.tar.gz.asc \
 && gpg --verify /tmp/hadoop.tar.gz.asc \
 && tar -xvf /tmp/hadoop.tar.gz -C ${HADOOP_HOME} --strip-components 1 \
 && rm /tmp/hadoop.tar.gz* \
 && mkdir ${HADOOP_HOME}/logs

ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV PATH=${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${PATH}

COPY conf/core-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/hdfs-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/yarn-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/mapred-site.xml "${HADOOP_CONF_DIR}/"
COPY conf/workers "${HADOOP_CONF_DIR}/"

# Hive
RUN curl -fSL https://archive.apache.org/dist/hive/KEYS -o /tmp/KEYS  \
 && gpg --import /tmp/KEYS

ENV HIVE_VERSION=2.3.9
#ENV HIVE_URL="https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"
ENV HIVE_HOME=/opt/hive

RUN set -x \
 && mkdir ${HIVE_HOME} \
 && curl -fSL "https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz" -o /tmp/hive.tar.gz \
 && curl -fSL "https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc" -o /tmp/hive.tar.gz.asc \
 && gpg --verify /tmp/hive.tar.gz.asc \
 && tar -xvf /tmp/hive.tar.gz -C ${HIVE_HOME} --strip-components 1 \
 && rm /tmp/hive.tar.gz*

RUN set -x \
 && rm ${HIVE_HOME}/lib/guava-* \
 && cp ${HADOOP_HOME}/share/hadoop/hdfs/lib/guava-* ${HIVE_HOME}/lib/

ENV HIVE_CONF_DIR=${HIVE_HOME}/conf
ENV PATH=${HIVE_HOME}/sbin:${HIVE_HOME}/bin:${PATH}

COPY conf/hive-site.xml "${HIVE_CONF_DIR}/"

# Spark
RUN curl -fSL https://archive.apache.org/dist/spark/KEYS -o /tmp/KEYS  \
 && gpg --import /tmp/KEYS

ENV SPARK_VERSION=3.2.1
#ENV SPARK_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION%.*}.tgz"
ENV SPARK_HOME=/opt/spark

RUN set -x \
 && mkdir ${SPARK_HOME} \
 && curl -fSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION%.*}.tgz" -o /tmp/spark.tgz \
 && curl -fSL "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION%.*}.tgz.asc" -o /tmp/spark.tgz.asc \
 && gpg --verify /tmp/spark.tgz.asc \
 && tar -xvf /tmp/spark.tgz -C ${SPARK_HOME} --strip-components 1 \
 && rm /tmp/spark.tgz*

ENV PYTHONHASHSEED=1
ENV SPARK_CONF_DIR="${SPARK_HOME}/conf"
ENV PATH=${SPARK_HOME}/sbin:${SPARK_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"

#COPY conf/core-site.xml "${SPARK_CONF_DIR}/"
#COPY conf/hdfs-site.xml "${SPARK_CONF_DIR}/"
#COPY conf/hive-site.xml ${SPARK_CONF_DIR}/
COPY conf/spark-defaults.conf "${SPARK_CONF_DIR}/"
#COPY conf/spark-env.sh "${SPARK_CONF_DIR}/"

#RUN ln -s ${SPARK_HOME}/jars/scala-library-*.jar ${HIVE_HOME}/lib \
# && ln -s ${SPARK_HOME}/jars/spark-core_*.jar ${HIVE_HOME}/lib \
# && ln -s ${SPARK_HOME}/jars/spark-network-common_*.jar ${HIVE_HOME}/lib

# Entry point
ENV USER=root
COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
RUN chmod a+x /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]