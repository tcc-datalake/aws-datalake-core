FROM apache/airflow:2.0.1-python3.8

ENV AIRFLOW_HOME=/usr/local/airflow

USER root

#configs
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt-get update && \
    apt-get install -y build-essential libpq-dev postgresql

COPY config/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}

COPY ./application/dags/ /usr/local/airflow/dags

ENTRYPOINT ["/entrypoint.sh"]
