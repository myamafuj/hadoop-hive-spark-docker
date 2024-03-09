build-base: ## build base image.
	docker build -t hadoop-hive-spark-base ./base
build-master: ## build master server image.
	docker build -t hadoop-hive-spark-master ./master
build-worker: ## build worker server image.
	docker build -t hadoop-hive-spark-worker ./worker
build-history: ## build history server image.
	docker build -t hadoop-hive-spark-history ./history
build-jupyter: ## build jupyter notebook image.
	docker build -t hadoop-hive-spark-jupyter ./jupyter
build-dev: ## build dev env.
	docker build -t hadoop-hive-spark-dev ./dev

build: ## build all images.
	build-base build-master build-worker build-history build-jupyter build-dev

help: ## print help.
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'