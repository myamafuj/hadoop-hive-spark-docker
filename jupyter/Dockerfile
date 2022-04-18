FROM mtakamot/hadoop-hive-spark-base

RUN sudo pip install pyarrow pandas openpyxl jupyter findspark

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
CMD ["run.sh"]