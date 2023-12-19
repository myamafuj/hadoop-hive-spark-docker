# Hadoop-Hive-Spark cluster + Jupyter on Docker

## Create docker network sparknet

```sh
docker network create --driver=bridge \
    --subnet=172.28.0.0/16 \
    --gateway=172.28.255.254 \
    sparknet
```