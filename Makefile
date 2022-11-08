build:
	docker build -t myamafuj/hadoop-hive-spark-base ./base
	docker build -t myamafuj/hadoop-hive-spark-master ./master
	docker build -t myamafuj/hadoop-hive-spark-worker ./worker
	docker build -t myamafuj/hadoop-hive-spark-history ./history
	docker build -t myamafuj/hadoop-hive-spark-jupyter ./jupyter

push:
	docker push myamafuj/hadoop-hive-spark-base
	docker push myamafuj/hadoop-hive-spark-master
	docker push myamafuj/hadoop-hive-spark-worker
	docker push myamafuj/hadoop-hive-spark-history
	docker push myamafuj/hadoop-hive-spark-jupyter
