# Database
### add bitnami repo
    helm3 repo add bitnami https://charts.bitnami.com/bitnami
### deploy MySQL to Okteto 
    helm3 install tech-exam-mysql -f chart/mysql/values.yaml bitnami/mysql

# Web
[Dockerfile](../Dockerfile), also add `.dockerignore`

[Makefile](../Makefile)

* Export Okteto API user and token
    ```
    export OKTETO_API_USER=<your okteto namespace>
    export OKTETO_API_TOKEN=<your personal access token>
    ```
* Run `make build` to build application and push to Okteto docker registry
* Run `make deploy` to deploy to Okteto using helm3

# Metrics
Consist of following components:   
* mysql_exporter:

    add `prometheus-community` repo
        
        helm3 repo add prometheus-community https://prometheus-community.github.io/helm-charts

    deploy `mysql_exporter` to scrape metrics from mysql database

        helm3 install tech-exam-prom-mysql-exporter -f chart/prometheus-mysql-exporter/values.yaml prometheus-community/prometheus-mysql-exporter

* prometheus: is deployed as part of `app` helm chart. A simple alert rule is setup to check if mysql database is down or not using `mysql_up` metrics

* grafana: is deployed as part of `app` helm chart.

# URLs
* [app](https://tech-exam-app-thanhh-nguyen.cloud.okteto.net/])
* [prometheus](https://tech-exam-app-prometheus-thanhh-nguyen.cloud.okteto.net/)
* [grafana](https://tech-exam-app-grafana-thanhh-nguyen.cloud.okteto.net/)

# Feedback
* Docker image is quite large, not sure if multi-stage builds can help because i don't have much knowledge about Ruby. I did use multi-stage builds for Golang application before.
* Couldn't initilise database from local machine (again Ruby knowledge shortage).
    ```
    bundle exec rake db:create
    bundle exec rake db:migrate
    ```
    Workaround by adding sleep into `App` deployment so that I could initiate database from kubernetes cluster. I can verbally explain more.
* Had to spend fair amount of time to understand `Okteto` and `Ruby` application.
* Unclear where `Ansible` would be used.