from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

def print_message():
    print("Funcionou...")

default_args = {
    'owner': 'teste',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'exemplo_airflow',
    default_args=default_args,
    description='Exibe a mensagem "funcionou 4..." a cada 4 minutos',
    schedule_interval=timedelta(minutes=4),
)

tarefa = PythonOperator(
    task_id='exibir_mensagem',
    python_callable=print_message,
    dag=dag,
)

tarefa

if __name__ == "__main__":
    dag.cli()
