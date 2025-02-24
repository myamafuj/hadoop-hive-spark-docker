import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types._

object WordCount {
	def main(args: Array[String]) {
		val spark = SparkSession.builder.appName("Scala Word Count App").master("local").getOrCreate()

        val inputFile = "hdfs://master/user/jupyter/data/words.txt"
        val df = spark.read.option("header", "true").csv(inputFile)
        df.show()
        val wordsDF = df.select(explode(split(col("text"), " ")).alias("word"))
        val wordsDFLower = wordsDF.withColumn("word", lower(col("word")))
        val filteredWordsDF = wordsDFLower.filter(col("word") =!= "")
        val wordCountDF = filteredWordsDF.groupBy("word").count().sort(col("count").desc)
        wordCountDF.show()
        wordCountDF.coalesce(1).write.format("parquet").mode("overwrite").save("hdfs://master/user/jupyter/output")
    
        spark.stop()
	}
}