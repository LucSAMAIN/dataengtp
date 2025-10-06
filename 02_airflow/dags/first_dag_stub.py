import pendulum
from datetime import timedelta

from airflow import DAG
from airflow.operators.empty import EmptyOperator

START_DATE = pendulum.datetime(2024, 1, 1, tz="UTC")

with DAG(
    dag_id="first_dag_stub",
    start_date=START_DATE,
    schedule=None,          # no schedule
    catchup=False,
<<<<<<< HEAD
)

task_one = DummyOperator(
    task_id='get_spreadsheet',
    dag=first_dag
)

task_two = DummyOperator(
    task_id='transmute_to_csv',
    dag=first_dag)

task_three = DummyOperator(
    task_id='time_filter',
    dag=first_dag
)

task_four = DummyOperator(
    task_id='load',
    dag=first_dag
)


task_five = DummyOperator(
    task_id='cleanup',
    dag=first_dag)


task_one >> task_two >> task_three >> task_four >> task_five

=======
    max_active_tasks=1,     # old 'concurrency'
    default_args={
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    tags=["stub"],
) as dag:
>>>>>>> 90e10ce (updated airflow for practice)

    get_spreadsheet = EmptyOperator(task_id="get_spreadsheet")
    transmute_to_csv = EmptyOperator(task_id="transmute_to_csv")
    time_filter = EmptyOperator(task_id="time_filter")
    load = EmptyOperator(task_id="load")
    cleanup = EmptyOperator(task_id="cleanup")

    get_spreadsheet >> transmute_to_csv >> time_filter >> load >> cleanup
