
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
import datetime
import os

import time
from pyspark.sql.functions import monotonically_increasing_id, expr, lit, when
 
# set the timezone to US/Pacific
os.environ['TZ'] = 'US/Eastern'
time.tzset()
 
# get the current time in the default timezone
now = datetime.datetime.now()
print(f'Inicio do processamento: {now}')

hora = now.strftime("%I")
dia_noite = now.strftime("%p")

if int(hora) >= 4 and dia_noite == 'PM':
    print('Processo iniciado apos o fechamento da bolsa de valores de Nova Iorque')
else:
    print('Processo iniciado antes do fechamento da bolsa de valores de Nova Iorque')
    shift = datetime.timedelta(max(1,(now.weekday() + 6) % 7 - 3))
    now = now - shift
bases = ['IBM','AAPL','MSFT']
for b in bases:
    print(f'Rodando a origem: {b}')
    origem = spark.read.parquet(f's3://datalake-core-raw/database=raw_finance/{b}/').drop('_airbyte_ab_id','_airbyte_additional_properties')

    print(f'Criando as colunas de index e data')
    
    origem = origem.withColumn('index',monotonically_increasing_id())
    
    origem = origem.withColumn('data', lit(''))
    
    origem = origem.withColumn('papel', lit(b))

    origem_total = origem.count()

    print(f'Quantidade de linhas da origem: {origem_total}')

    print(f'Adicionando as datas na origem')
    
    syntax = 'CASE '
    
    for linha in range(origem_total):
        if linha == 0:
            data = f'{now.year}{now.month:02}{now.day:02}'
            syntax_append = f'WHEN INDEX = {linha} THEN {data} '
        elif linha == 1:
            shift = datetime.timedelta(max(1,(now.weekday() + 6) % 7 - 3))
            day = now - shift
            data = f'{day.year}{day.month:02}{day.day:02}'
            syntax_append = f'WHEN INDEX = {linha} THEN {data} '
        else:
            shift = datetime.timedelta(max(1,(day.weekday() + 6) % 7 - 3))
            day = day - shift
            data = f'{day.year}{day.month:02}{day.day:02}'
            syntax_append = f'WHEN INDEX = {linha} THEN {data} '
        
        syntax += syntax_append
    
    syntax += 'END'
        #print(data)
    origem = origem.withColumn('data', expr(syntax))
    
    print(f'Escrevendo o parquet')
    origem = origem.withColumnRenamed('_airbyte_emitted_at','insert_time').withColumnRenamed('_3__low','preco_mais_baixo')\
                    .withColumnRenamed('_5__volume','volume').withColumnRenamed('_1__open','preco_abertura')\
                    .withColumnRenamed('_2__high','preco_mais_alto').withColumnRenamed('_4__close','preco_fechamento')
    
    origem = origem.select('index','data','papel','volume','preco_abertura','preco_fechamento','preco_mais_baixo','preco_mais_alto','insert_time')
    origem.write.mode('overwrite').parquet(f's3://datalake-core-trusted/database=trusted_finance/{b}/')

print(f'Processo finalizado')
job.commit()