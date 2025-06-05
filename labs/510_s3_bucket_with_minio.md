# S3 Bucket einrichten mit MinIO

1. Die Datei `requirements.txt` anpassen:
    ```diff
    ...
    -dvc==3.59.2
    +dvc[s3]==3.59.2
    ...
    ```
1. Abhängigkeiten installieren (zuerst prüfen das man sich im virtuellen Environment befindet, ansonsten mit `source .env/bin/activate` aktivieren):
    ```shell
    pip install -r requirements.txt
    ```
1. Die Datei `docker-compose.yaml` erstellen mit folgendem Inhalt:
    ```shell
    services:
    minio:
      image: minio/minio:RELEASE.2021-02-11T08-23-43Z
      container_name: s3
      ports:
        - "9000:9000"
      command: minio server data/
  
    aws:
      image: amazon/aws-cli
      container_name: aws-cli
      command: -c "sleep 2 && aws --endpoint-url http://minio:9000 s3 mb s3://dvc-digits --region eu-west-1 || exit 0"
      entrypoint: [/bin/bash]
      environment:
        AWS_ACCESS_KEY_ID: minioadmin
        AWS_SECRET_ACCESS_KEY: minioadmin
      depends_on:
        - minio
    ```
1. Die Container mit folgendem Befehl hochfahren:
    ```shell
    docker compose up -d  
    ```
1. Mit folgendem Befehl können die Logs der Container eingesehen werden:
    ```shell
    docker compose logs -f
    ```
1. Unter http://locahost:9000 kann man auf den MinIO Browser zugreifen (usr: `minioadmin`, pwd: `minioadmin`) und das Bucket einsehen.
1. DVC Remote hinzufügen mit:
    ```shell
    dvc remote add -d minio s3://dvc-digits
    ```
1. Konfiguration Storage URL und credentials:
    ```shell
    dvc remote modify minio endpointurl http://localhost:9000
    dvc remote modify minio access_key_id minioadmin
    dvc remote modify minio secret_access_key minioadmin
    ```
    **ACHTUNG**: Hier nutzen wir eine lokale Testumgebung, daher können wir den `secret_access_key` im GitHub einchecken. **Dies darf mit einem produktiven Key NICHT getan werden!** Dazu stellt DVC den parameter `--local` zur Verfügung, mit welchem die Konfiguration nur lokal in `.dvc/config.local` abgelegt wird. Hier die Befehle wenn man ein produktives Repository nutzen würde:
    ```shell
    dvc remote modify --local minio access_key_id minioadmin
    dvc remote modify --local minio secret_access_key minioadmin
    ```
1. Nun können die Dateien mit folgendem Befehl in den Bucket gepusht werden:
    ```shell
    dvc push
    ```
1. Auf http://localhost:9000 sieht man im Bucket ein neues Verzeichnis `files` in welchem DVC die Dateien verwaltet.
1. Änderungen pushen mit:
    ```shell
    git add .
    git commit -m "Use local minio in docker container."
    git push
    ```

## Self-Hosting Runner mit Zugriff auf lokales minio

Aktuell hat der GitHub Action Runner oder der Self-Hosting Runner keinen Zugriff auf das lokale minio. Daher wird hier beschrieben wie dies erreicht werden kann.

1. In `docker-compose.yaml` folgenden Service hinzufügen:
    ```diff
    ...
    + runner:
    +   image: iterativeai/cml:0-dvc3-base1
    +   container_name: runner
    +   command: cml runner --
    +   environment:
    +     RUNNER_IDLE_TIMEOUT: 1800
    +     RUNNER_LABELS: cml,vm
    +     RUNNER_REPO: $repo_url
    +     REPO_TOKEN: $repo_token
    +   
    ...
    ```
1. In einem Terminal den Container wie folgt hochfahren (falls `repo_url` und `repo_token` noch nicht gesetzt sind, dies wie in [Self-hosted Runner](500_self_hosted_runner.md) beschrieben zuerst setzen):
    ```shell
    docker compose up -d
    ```
1. Ändern der remote url:
    ```shell
    dvc remote modify minio endpointurl http://minio:9000
    ```
1. Wenn wir lokal arbeiten, wollen wir minio über `localhost` erreichen, daher können wir nun mit `--local` die `endpointurl` für `minio` anpassen: 
    ```shell
    dvc remote modify --local minio endpointurl http://localhost:9000
    ```
1. Nun können wir auch im Runner die Files vom lokalen S3 Bucket holen und die Datei `.github/workflows/cml.yaml` erweitern:
    ```diff
    ...
      - name: Train model
        run: |
          cat requirements.txt | grep -v -e jupyter > ci_requirements.txt
          pip install -r ci_requirements.txt
    +     dvc pull
          PYTHONPATH=$PWD dvc repro
    +     dvc push
      - name: Create CML report
    ...
    ```
1. Änderungen pushen mit:
    ```shell
    git add .
    git commit -m "Use self-hosted runner with local minio."
    git push
    ```

## Zusätzliche Dokumentation

- [Run S3 Locally With MinIO for the DVC Machine Learning Pipeline](https://betterprogramming.pub/run-s3-locally-with-minio-for-dvc-machine-learning-pipeline-7fa3d240d3ab)
