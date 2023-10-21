# Daten und Modell versionieren

1. Zum Experimentieren eine lokale DVC Ablage hinzufügen:
    ```shell
    dvc remote add -d local /tmp/dvc/digits
    ```
    In der Realität würde diese Ablage z.B. auf einem S3-Bucket auf AWS liegen, wo wir alle Versionen unserer Daten speichern. Die Konfiguration wie auch weitere mögliche Ablagen ist der Dokumentation zu entnehmen: https://dvc.org/doc/command-reference/remote#remote

1. Der obige Befehl hat eine Änderung an `.dvc/config` vorgenommen, diese Änderung muss in Git hinzugefügt werden:
    ```shell
    git add .dvc/config
    git commit -m "Add dvc remote (local)"
    git push
    ```
1. Pipeline ausführen damit alle Daten generiert werden und vorhanden sind:
    ```shell
    dvc repro
    ```
1. Daten hinzufügen:
    ```shell
    dvc push
    ```
1. Unter `/tmp/dvc/digits/` wurde ein Ordner `files` erstellt.

## Daten herunterladen

DVC speichert Ausführungen der Pipeline sowie Daten in einem Cache unter `.dvc/cache`.

1. Cache löschen:
    ```shell
    rm -rf .dvc/cache
    ```
1. Status mit DVC prüfen:
    ```shell
    dvc status
    ```
1. Dateien neu herunterladen mit:
    ```shell
    dvc pull
    ```

## Änderung von abhängigen Parametern und Cache

1. Ausführen der Pipeline:
    ```shell
    dvc repro
    ```
1. Keine der Stages wurde ausgeführt, weil sich nichts verändert hat.
1. Den Parameter `test_size` in `params.yaml` von `0.5` auf `0.2` setzen und die Datei speichern.
1. Wenn man sehen will, welche Stages von der Änderung betroffen sind, kann man dies mit `dvc status` tun. Es werden die Stages aufgelistet und welche abhängigen Parameter sich geändert haben.
1. Ausführen der Pipeline:
    ```shell
    dvc repro
    ```
1. Prüfen welche Dateien sich geändert haben:
    ```shell
    dvc diff
    ```
1. Den Parameter `test_size` in `params.yaml` von `0.2` auf `0.3` setzen und die Datei speichern.
    ```shell
    dvc repro
    ```
1. Parameter `test_size` in `params.yaml` wieder auf `0.2` setzen und die Datei speichern.
1. Ausführen der Pipeline:
    ```shell
    dvc repro
    ```
1. Man sieht, dass die Stages nicht noch einmal ausgeführt werden. Es wird alles aus dem Cache geladen und nur die Datei `dvc.lock` wird aktualisiert.
1. Parameter `test_size` in `params.yaml` wieder auf `0.5` setzen und die Datei speichern.
1. Ausführen von:
    ```shell
    dvc repro
    ```
1. Beim Ausführen der folgenden Befehle, sollten nun keine Änderungen mehr angezeigt werden, da wir wieder im ursprünglichen Zustand mit `test_size=0.5` sind:
    ```shell
    git status
    dvc status
    ``` 

## Zusätzliche Dokumentation

- [Get Started: Data Versioning](https://dvc.org/doc/start/data-management/data-versioning#get-started-data-versioning)
- [DVC Command Reference](https://dvc.org/doc/command-reference)
    - [diff](https://dvc.org/doc/command-reference/diff#diff)
    - [status](https://dvc.org/doc/command-reference/status#status)
    - [push](https://dvc.org/doc/command-reference/push#push)
    - [pull](https://dvc.org/doc/command-reference/pull#pull)

---

[← Pipeline zusammenstellen](020_lab_init_pipeline.md) | [STARTSEITE](../README.md) |
[Metriken und Experimente →](040_lab_metrics.md)
