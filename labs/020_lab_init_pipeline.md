# Pipeline zusammenstellen

## DVC installieren

1. Falls dvc noch nicht im `requirements.txt` eingetragen ist, diese hinzufügen:
    ```diff
    scikit-learn==1.3.0
    matplotlib==3.7.2
    pandas==2.0.3
    +dvc=3.15.0
    jupyterlab==4.0.3
    ```
1. Die neue Abhängigkeit installieren mit folgendem Befehl 
(**ACHTUNG**: falls man sich nicht schon im virtuellen Environment befindet, unbedingt zuerst mit `source .env/bin/activate` aktivieren!):
    ```shell
    pip install -r requirements.txt
    ``````

## DVC initialisieren

1. Das Repository für DVC initialiseren mit:
    ```shell
    dvc init
    ```
1. **Optional** Analytics ausschalten (siehe https://dvc.org/doc/user-guide/analytics).
    ```shell
    dvc config core.analytics false
    ```
1. DVC hat ein Verzeichnis `.dvc` und eine Datei `.dvcignore` erstellt. Diese müssen in Git eingecheckt werden.
    ```shell
    git add .
    git commit -m "Init DVC repo."
    git push
    ```

## Stages erstellen

### Daten laden

Um die Stage `data_load` zu erstellen, folgenden Befehl ausführen:

```shell
dvc stage add -n data_load \
    -d src/data_load.py \
    -o data/raw/data_digits.joblib \
    -p base,data \
    python src/data_load.py --config params.yaml
```

Man kann nun mit `dvc repro` die Pipeline ausführen. Bei der ersten Ausführung werden die Daten geladen. Bei einer zweiten Ausführung wird keine Aktion durchgeführt, da sich nichts geändert hat. Will man trotzdem die Ausführung forcieren, kann dies mit `dvc repro -f` erreicht werden.

Löscht man mit `rm data/raw/data_digits.joblib` das von der Stage `data_load` erstellte Artefakt, wird `dvc status` diese Datei als gelöscht melden.

Ein `dvc repro` wird `data/raw/data_digits.joblib` wieder erstellt.

### Daten vorbereiten

Die Stage `data_prepare` mit folgendem Befehl erstellen:

```shell
dvc stage add -n data_prepare \
    -d src/data_prepare.py \
    -d data/raw/data_digits.joblib \
    -o data/processed/digits.csv \
    -p base,data \
    python src/data_prepare.py --config params.yaml
```

Mit `dvc repro` die Pipeline testen.

Mit `dvc dag` lässt sich die bis jetzt vorhandene Pipeline darstellen.

### Daten splitten

Eine Stage kann auch manuell im `dvc.yaml` hinzugefügt werden. Dazu `dvc.yaml` öffnen und folgende Zeilen hinzufügen:

```yaml
data_split:
    cmd: python src/data_split.py --config params.yaml
    deps:    
    - src/data_split.py
    - data/processed/digits.csv
    params:
    - base
    - data
    outs:
    - data/train/train.csv
    - data/test/test.csv
```

Danach die Datei speichern und mit `dvc repro` und `dvc dag` die Pipeline prüfen.

### Training

Hinzufügen der Stage `train` mit:

```shell
dvc stage add -n train \
    -d src/train.py \
    -d data/train/train.csv \
    -o models/model.joblib \
    -p base,data,train \
    python src/train.py --config params.yaml
```

### Evaluate

Hinzufügen der Stage `evaluate` mit:

```shell
dvc stage add -n evaluate \
    -d src/evaluate.py \
    -d data/test/test.csv \
    -d models/model.joblib \
    -o reports/metrics.json \
    -o reports/confusion_matrix.png \
    -p base,data,train,reports \
    python src/evaluate.py --config params.yaml
```

## Änderungen auf GitHub übertragen

```shell
git add .
git commit -m "Automate pipeline."
git push
```
