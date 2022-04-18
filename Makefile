build:
	docker build -t mtakamot/hadoop-hive-spark-base ./base
	docker build -t mtakamot/hadoop-hive-spark-master ./master
	docker build -t mtakamot/hadoop-hive-spark-worker ./worker
	docker build -t mtakamot/hadoop-hive-spark-history ./history
	docker build -t mtakamot/hadoop-hive-spark-jupyter ./jupyter

push:
	docker push mtakamot/hadoop-hive-spark-base
	docker push mtakamot/hadoop-hive-spark-master
	docker push mtakamot/hadoop-hive-spark-worker
	docker push mtakamot/hadoop-hive-spark-history
	docker push mtakamot/hadoop-hive-spark-jupyter
