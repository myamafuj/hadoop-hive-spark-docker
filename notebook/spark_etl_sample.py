#!/usr/bin/env python
# coding: utf-8
import sys
import argparse
from pyspark import SparkConf
from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType
import json

# parser
class ParamProcessor(argparse.Action):
    """
    --param foo=a型の引数を辞書に入れるargparse.Action
    """
    def __call__(self, parser, namespace, values, option_strings=None):
        param_dict = getattr(namespace,self.dest,[])
        if param_dict is None:
            param_dict = {}

        k, v = values.split("=")
        param_dict[k] = v
        setattr(namespace, self.dest, param_dict)

def main():

    # 引数の処理
    parser = argparse.ArgumentParser(description='args')
    parser.add_argument('-a', '--appName', type=str, required=True, help='application name displaied at spark history server')
    parser.add_argument('-s', '--sql', type=str, required=False, help='specify sql path')
    parser.add_argument('-b', '--sqlBinding', required=False, help='sql placeholder ex. --sqlBinding dt=2019-01-01 --sqlBinding action=show',action=ParamProcessor)
    parser.add_argument('-t', '--tableName', type=str, required=False, help='specify sql path')
    parser.add_argument('-z', '--struct', type=str, required=False, default=None, help='specify schema path')
    parser.add_argument('-f', '--file', type=str, required=False, default=None, help='specify data source path')

    args = parser.parse_args()
    parser=argparse.ArgumentParser()

    # spark sessionの作成
    spark = SparkSession.builder \
    .appName("chapter5") \
    .config("hive.exec.dynamic.partition", "true") \
    .config("hive.exec.dynamic.partition.mode", "nonstrict") \
    .config("spark.sql.session.timeZone", "JST") \
    .config("spark.ui.enabled","true") \
    .config("spark.eventLog.enabled","true") \
    .enableHiveSupport() \
    .getOrCreate()

    print(args)

    #SQLを読み込む(etl.sqlを読み込んでみます)
    # S3などのオブジェクトストレージでも大丈夫です
    df=spark.read.option("encoding", "utf-8").text(args.sql)
    query=' \n '.join([str(x.asDict()['value']) for x in df.collect()])

    # プレースホルダーに値をセットする
    if args.sqlBinding is not None:
      query=query.format(**args.sqlBinding)

    print(query)

    # スキーマを読み込む
    # S3などのオブジェクトストレージでも大丈夫です
    schema_df=spark.read.option("encoding", "utf-8").text(args.struct)
    struct=' '.join([str(x.asDict()['value']) for x in schema_df.collect()])
    schema_json=json.loads(struct)

    # jinko.csvの読み込み
    df=spark.read.option("multiLine", "true") \
        .option("encoding", "SJIS") \
            .csv(args.file, header=False, sep=',', inferSchema=False, schema=StructType.fromJson(schema_json))

    #　テンポラリテーブルを作成する(jinkoテーブル)
    df.createOrReplaceTempView(args.tableName)

    # SQLを発行する(今回はinsert 文)
    etl=spark.sql(query)

    #以降にselectしてきてdataframeの処理を書いてももちろん問題なしです。

    # 最後は停止処理をします
    spark.stop()

if __name__ == '__main__':
    main()
