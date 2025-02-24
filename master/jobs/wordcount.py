import findspark
findspark.init('/opt/spark')
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, lower
from pyspark.sql.types import StringType

spark = SparkSession.builder.appName("PySpark Word Count from CSV").getOrCreate()

input_file = "hdfs://master/user/jupyter/data/words.txt"
df = spark.read.option("header", "true").csv(input_file)
df.show()
words_df = df.select(explode(split(col("text"), " ")).alias("word"))
words_df = words_df.withColumn("word", lower(words_df["word"]))
words_df = words_df.filter(words_df["word"] != "")
word_count_df = words_df.groupBy("word").count().sort(col("count").desc())
word_count_df.show()
word_count_df.coalesce(1).write.format("parquet").mode("overwrite").save("hdfs://master/user/jupyter/output")

spark.stop()