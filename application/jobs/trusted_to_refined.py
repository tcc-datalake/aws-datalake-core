import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
  
sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

table1 = spark.read.parquet("s3://datalake-core-trusted/database=trusted_finance/AAPL/")
table2 = spark.read.parquet("s3://datalake-core-trusted/database=trusted_finance/IBM/")
table3 = spark.read.parquet("s3://datalake-core-trusted/database=trusted_finance/MSFT/")

result_table = table1.unionAll(table2).unionAll(table3)

result_table.write.mode("overwrite").parquet("s3://datalake-core-refined/database=refined_finance/FINANCE")

spark.stop()
job.commit()