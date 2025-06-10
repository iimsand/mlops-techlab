# Modell manuell testen

Um das Modell auch einmal manuell testen zu können, erstellen wir eine kleine Applikation.

## Abhängigkeiten installieren

1. In der Datei `requirements.txt` folgendes hinzufügen und speichern:
    ```diff
    gradio==3.48.0
    scikit-image==0.25.2
    ```
2. Danach die Abhängigkeiten installieren.
    ```shell
    pip install -r requirements.txt
    ```

## Applikation erstellen und starten

1. Die Datei `src/app.py` erstellen und den Code aus https://github.com/iimsand/mlops-techlab-digits-template/blob/exercise/060_lab_deploy_model/src/app.py kopieren.
1. Die Datei speichern.
1. Applikation starten mit:
    ```shell
    python src/app.py
    ```
1. Es dauert nun ein paar Sekunden, bis eine Meldung mit einer öffentlichen URL erscheint die mit `gradio.live` endet (**ACHTUNG**: es erscheint auch eine lokale URL, diese kann aber mit Codespaces nicht genutzt werden!):
    ```
    Running on public URL: https://<ZEICHENFOLGE>.gradio.live
    ```
1. Die URL kopieren und in einem Browser öffnen.

## Testen

Nun kann man auf der Zeichenfläche eine Zahl zeichnen und das Modell versucht diese zu erkennen.

Hast du aber das Problem, dass dein Modell die Zahlen nur sehr selten bis gar nie erkennt? Obwohl dein Modell bei der Evaluierung einen `f1-score` von über `0.9` berechnet und auch die Confusion Matrix zeigt, dass die meisten Zahlen korrekt erkannt werden?

Woran könnte das liegen?

**Tipp**: Füge die folgende Zeile in der Datei `src/app.py` ein, um die Input Daten für das Modell auf der Konsole auszugeben:
```python
logger.info(f"INPUT_DATA: {input_data}")
```

---

[← GitHub Actions](050_lab_github_actions.md) | [STARTSEITE →](../README.md)
