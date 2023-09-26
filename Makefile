apply:
	cd scripts && ./deploy.sh apply airflow

destroy:
	cd scripts && ./deploy.sh destroy

plan:
	cd scripts && ./deploy.sh plan