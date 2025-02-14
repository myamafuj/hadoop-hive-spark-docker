import findspark
findspark.init('/opt/spark')
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()