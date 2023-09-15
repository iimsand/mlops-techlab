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

Wir können nun ein paar Experimente mit anderen Parametern durchführen und vergleichen.

### Sigmoid Kernel

```shell
dvc exp run -n kernel-sigmoid --set-param train.svc_params.kernel=sigmoid

dvc exp show
```

Wir sehen nun ein Experiment, dass von unserem Branch aus gestartet wurde und vermutlich einen tieferen `f1 score` aufweist.

### Sigmoid Kernel mit anderer `test_size`

```shell
dvc exp run -n kernel-sigmoid-1 -S train.svc_params.kernel=sigmoid -S data.test_size=0.2

dvc exp show
```

Auch dieses Experiment wird aufgelistet, doch der `f1 score` ist nun sehr tief. Das Modell scheint nicht sehr gut zu funktionieren.

### Verschiedene Werte ausprobieren

Wir können auch mehrere Experimente mit verschiedenen Kombinationen von Parametern ausführen.

Dazu erstellen wir zuerst unsere Experimente:

```shell
dvc exp run --queue \
    -S train.svc_params.kernel='linear,poly' \
    -S 'train.svc_params.C=range(0.01, 0.1, 0.05)'

dvc exp show
```

Wir sehen nun alle Experimente aufgelistet in einem State `Queued`. Doch durch die ganzen Spalten, sehen wir nicht auf den ersten Blick, welches Experiment welche Parameter benutzt.

Eine Möglichkeit, eine bessere Übersicht zu gewinnen, ist `dvc exp show` wie folgt aufzurufen:

```shell
dvc exp show --only-changed
```

Die Tabelle könnte noch weiter angepasst werden. Einige Beispiele sind unter https://dvc.org/doc/command-reference/exp/show#examples zu finden.

Nun können wir die Experimente starten mit

```shell
dvc queue start
```

Es dauert nun einige Zeit, bis alle Experimente ausgeführt wurden. Den Status der Queue können wir mit folgendem Befehl überprüfen:

```shell
dvc queue status
```

### Experiment weiterverfolgen

Haben wir in unseren Experimenten einen vielversprechenden Kandidaten gefunden den wir weiterverfolgen wollen. Können wir hiervon einen Branch erstellen. Dazu den Namen des gewünschten Experiments auswählen und mit folgendem Befehl einen Branch erstellen:

```shell
dvc exp branch <NAME_DES_EXPERIMENTS>

# show branches
git branch
```

DVC hat uns einen Branch erstellt auf welchen wir wechseln, alles in Git und DVC hinzufügen und pushen könnten. Aktuell wechseln wir aber den Branch nicht und bleiben auf dem aktuellen.

### Experimente bereinigen

Beim Experimentieren sammeln sich einige Experimente an. Diese können mit folgendem Befehl bereinigt werden:

```shell
dvc exp remove --all
dvc exp clean
```

Auch Änderungen im Git-Workspace sollten bereinigt werden damit dieser wieder sauber ist.

```shell
git checkout .
```

## Zusätzliche Dokumentation

- [DVC Command Reference](https://dvc.org/doc/command-reference)
    - [exp](https://dvc.org/doc/command-reference/exp#exp)
