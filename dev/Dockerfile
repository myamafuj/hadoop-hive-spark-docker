FROM hadoop-hive-spark-base AS base
FROM tensorflow/tensorflow

RUN sed -i -e "s|http://archive.ubuntu.com|http://ca.archive.ubuntu.com|g" /etc/apt/sources.list \
 && apt-get -qq update  \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
      sudo \
      openjdk-8-jdk \
      curl \
      coreutils \
      libc6-dev \
 && rm -rf /var/lib/apt/lists/*

ARG USERNAME=jupyter
ARG GROUPNAME=jupyter
ARG UID=1001
ARG GID=1001

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
 && chmod 0440 /etc/sudoers.d/$USERNAME \
 && groupadd -g $GID $GROUPNAME \
 && useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

USER $USERNAME

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Hadoop
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/hadoop /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

# Spark
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/spark /opt/spark
ENV SPARK_HOME=/opt/spark
ENV PYTHONHASHSEED=1
ENV PYSPARK_PYTHON=python3
ENV SPARK_CONF_DIR=$SPARK_HOME/conf
ENV PATH=$SPARK_HOME/sbin:$SPARK_HOME/bin:$PATH

# Hive
COPY --from=base --chown=$USERNAME:$GROUPNAME /opt/hive /opt/hive
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=$HIVE_HOME/conf
ENV PATH=$HIVE_HOME/sbin:$HIVE_HOME/bin:$PATH

RUN sudo pip install -U pip &&\
    sudo pip install --no-cache-dir \
    pandas \
    openpyxl \
    findspark \
    tensorflow-serving-api
    
# Install miniconda
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && sudo /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    && sudo chown $USERNAME:$GROUPNAME -R $CONDA_DIR \
    && sudo mkdir /home/$USERNAME/conda-env \
    && sudo mkdir /home/$USERNAME/data \
    && sudo chown $USERNAME:$GROUPNAME -R /home/$USERNAME/conda-env \
    && sudo chown $USERNAME:$GROUPNAME -R /home/$USERNAME/data 
# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Config
COPY --chown=$USERNAME:$GROUPNAME conda-env/hello-spark.yml /home/$USERNAME/conda-env/
COPY --chown=$USERNAME:$GROUPNAME data/* /home/$USERNAME/data/
# RUN conda env create -f /home/$USERNAME/conda-env/hello-spark.yml \
#     && conda activate hello-spark

WORKDIR /home/$USERNAME