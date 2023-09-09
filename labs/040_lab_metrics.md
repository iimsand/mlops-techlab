# Metriken und Experimente

## Metriken

1. Ausführen von
    ```shell
    dvc exp show
    ```
    - Man sollte aktuell 2 Experimente `workspace` und `main` sehen.
    - Mit den Pfeiltasten links/rechts kann die Tabelle hin- und hergeschoben werden.
    - Man sieht zwar die Parameter aus dem `param.yaml` und die Hashes der Dateien, aber keine Metriken wie z.B. der `f1 score`.
1. Im `dvc.yaml` die Stage `evaluate` wie folgt anpassen:
    ```diff
    evaluate:
      cmd: python src/evaluate.py --config params.yaml
      deps:
      - data/test/test.csv
      - models/model.joblib
      - src/evaluate.py
      params:
      - base
      - data
      - reports
      - train
      outs:
      - reports/confusion_matrix.png
    - - reports/metrics.json
    + metrics:
    + - reports/metrics.json:
    +     cache: false
    ```
    Mit `cache: false` wird die Datei mit Git kontrolliert und nicht mit DVC. Die Regel ist: kleine Dateien in Git und grosse Dateien in DVC.
1. Damit die Datei `reports/metrics.json` von Git nicht mehr ignoriert wird, muss dies in `.gitignore` wie folgt geändert werden:
    ```diff
    ...

    data/*
    models/*
    reports/*

    +!reports/metrics.json
    ```
1. Wird nun `dvc exp show` aufgerufen, sieht man in der 3. Spalte den `f1 score` aufgeführt. Dieser ist nur in unserem `workspace` ersichtlich, da sich auf dem `main` noch kein Experiment befindet.
1. Alles in Git und DVC hinzufügen:
    ```shell
    git add .
    git commit -m "Show f1 metrics in dvc exp"
    git push
    dvc push
    ```

## Experimente

$\colorbox{yellow}{{\color{gray}{TODO}}}$ _Aufzeigen wie mit `dvc exp` Experimente gestartet werden können und mit Hands-on ergänzen._

## Zusätzliche Dokumentation

- [DVC Command Reference](https://dvc.org/doc/command-reference)
    - [exp](https://dvc.org/doc/command-reference/exp#exp)
