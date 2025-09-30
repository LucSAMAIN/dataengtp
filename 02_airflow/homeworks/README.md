# Task 3: assignment_dag — extended exercise (API + logging + DB)

This DAG turns the concepts into a realistic pipeline: it calls a public API (D&D 5e), generates synthetic data, branches on runtime conditions, merges intermediate JSONs, and executes SQL against Postgres using SQLExecuteQueryOperator. It includes structured logging and a failure callback for clear console diagnostics.

## Highlights

* Modern imports:

  ```python
  from airflow.providers.standard.operators.python import PythonOperator, BranchPythonOperator
  from airflow.providers.standard.operators.empty import EmptyOperator
  from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
  ```
* Structured logging with `logging.getLogger(__name__)`
* Robust API calls with timeouts
* Avoids “template file not found” by generating SQL in a Python task and passing it via XCom:

  ```python
  tenth_node = SQLExecuteQueryOperator(
      task_id="insert_inserts",
      conn_id="postgres_not_default",
      sql="{{ ti.xcom_pull(task_ids='generate_sql') }}",
      autocommit=True,
  )
  ```

## Steps

1. **Prereqs:**

   * Airflow ≥ 3.x
   * Providers: `apache-airflow-providers-common-sql`, `apache-airflow-providers-postgres`
   * Outbound network allowed to `https://www.dnd5eapi.co/api`
   * Airflow connection (create new database)`postgres_not_default` pointing to your DB
2. **Paths:** default artifact dir is `/opt/airflow/data`. Create it and ensure write perms.
3. **Place the DAG:** create file `assignment_dag.py` in `dags/`.
4. **Enable & trigger**: UI
5. **Execution order (happy path):**
   `name_race → attributes → language → class → proficiency_choices → levels → spell_check → (spells?) → merge → generate_sql → insert_inserts → finale`
6. **Logging tips:**

   * Operator logs show `INFO`/`DEBUG` breadcrumbs and full tracebacks on failure.
   * To increase verbosity globally:

     ```bash
     # docker-compose env
     AIRFLOW__LOGGING__LOGGING_LEVEL=DEBUG
     ```

     or set `[logging] logging_level = DEBUG` in `airflow.cfg`.
