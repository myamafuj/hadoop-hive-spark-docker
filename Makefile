build:
	docker build -t hadoop-hive-spark-base ./base
	docker build -t hadoop-hive-spark-master ./master
	docker build -t hadoop-hive-spark-worker ./worker
	docker build -t hadoop-hive-spark-history ./history
	docker build -t hadoop-hive-spark-jupyter ./jupyter
