## This is a develop env for Hadoop-Hive-Spark cluster + Jupyter on Docker

This docker is originated from [hadoop-hive-spark-docker](https://github.com/myamafuj/hadoop-hive-spark-docker)

This docker includes 7 containers (I removed jupyter container, so it is 6 containers for me):

- metastore container (postgres database)
- dev container (development container, hadoop, hive, spark, tensorflow and conda installed)
- master container (master container, containers, hadoop, hive, spark installed)
- two worker containers(containers, hadoop, hive, spark installed)
- history container(containers, hadoop, hive, spark installed)

and on top of that, a sparknet configured as below is needed. 

GPU part is commented, as it's not supported in my machine.

In case if you need add a kafka service in the future, you can simply add it as a service.

## Create docker network sparknet, with subnet and gateway configured

```sh
docker network create --driver=bridge \
    --subnet=172.28.0.0/16 \
    --gateway=172.28.255.254 \
    sparknet
```

```sh
docker network connect sparknet container
```

```sh
conda create --name MySpark python=3.11
# or
conda env create --file ~/conda-env/hello-spark.yml
```