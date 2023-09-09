# Prototyp ML-Experiment

Wir haben ein Jupyter-Notebook mit dem Prototypen [notebooks/prototyp.ipynb](notebooks/prototype.ipynb) erstellt.

Damit du den Code im Jupyter-Notebook ausführen kannst, musst du die Python-Umgebung konfigurieren. Danach kannst du entweder mit `Run All` alle Codeabschnitte oder mit dem Pfeil links neben dem Codeabschnitt den einzelnen Abschnitt ausführen.  

1. Die Datei [notebooks/prototyp.ipynb](notebooks/prototype.ipynb) öffnen.
1. Die erstellte Python-Umgebung wie folgt konfigurieren:
    1. Oben rechts _Select Kernel_ wählen.   
        ![](./screenshots/vscode-select-kernel-00.png)
    1. Im Menü _Python Environments..._ klicken:   
        ![](./screenshots/vscode-select-kernel-01.png)
    1. Das vorher erstellte Environment `.env` auswählen:
        ![](./screenshots/vscode-select-kernel-02.png)
1. Codeabschnitte ausführen
    * Alle gemeinsam ausführen:  
        ![](./screenshots/jupyter-run-all-blocks.png)

    * Einzelner Abschnitt ausführen

        Logischerweise müssen die Abschnitte in der gegebenen Reihenfolge ausgeführt werden, da sonst die Abhängigkeiten nicht gegeben sind.
        
        ![](./screenshots/jupyter-run-block.png)
