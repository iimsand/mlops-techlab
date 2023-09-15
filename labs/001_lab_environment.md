# Umgebung vorbereiten

Das Lab kann vollständig mit GitHub-Codespaces druchgeführt werden. Dafür bauchst du einen GitHub-Account.

**Wir empfehlen die Durchführung des Labs unbedingt mit GitHub Codespaces.** Dies aus folgenden Gründen:
- die Zeit für das Lab ist sehr kurz
- die Labs wurden mit GitHub Codespaces getestet
- Vermeidung von Installationsproblemen auf dem lokalen System (z.B. falsche Python Version, System Libraries fehlen, etc.)

Wer will, kann die Labs aber auch lokal durchführen. Eine detaillierte Installationsanleitung befindet sich in [Lokale Umgebung aufsetzen](002_lab_environment_local.md).

## GitHub-Repository

Es existiert ein Template Repository unter https://github.com/iimsand/mlops-techlab-digits-template. Dieses Repository dient als Startpunkt für dein eigenes Repository und enthält auch Lösungen zu jedem Lab, falls du einmal nicht weiterkommen solltest, kannst du die Dateien vom entsprechenden Branch kopieren. Das Repository ist schreibgeschützt und du musst dein eigenes Repository erstellen.

Dein Repository kannst du wie folgt erstellen:

1. "Use this template" aufklappen und "Create new repository" klicken:   
![GitHub create repo from template](screenshots/github_repo_create_from_template.png)
1. Repository name "digits" wählen und auf "Private" setzen:   
![GitHub create repo from template - info](screenshots/github_repo_create_from_template_info.png)

## GitHub-Codespace

Aus deinem neu erstellten Repository kannst du nun GitHub-Codespace öffnen.

1. Kontrolliere ob du dich auf deinem eigenen Repository befindest: https://github.com/<GIT_USER>/digits
1. Unter "Code -> Codespaces" kannst du nun mit "Create codespace on main" die Umgebung starten:   
![GitHub start codespace](screenshots/github_repo_start_codespace.png)

Weiter Informationen zu codespace: https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace-for-a-repository

### Python konfigurieren

Bei einer lokalen Installation sollten wir eine virtuelle Python Umgebung nutzen, doch wenn wir mit GiHub-Codespace arbeiten, ist dies nicht nötig.

Doch müssen in GitHub-Codespace trotzdem noch ein paar Konfigurationen für Python vorgenommen werden. Alle Abhängigkeiten aus dem `requirements.txt` werden zwar automatisch installiert, doch wurden noch nicht alle Pfade korrekt gesetzt.

Dazu im Terminal die folgenden Befehle ausführen:

```shell
echo "export PATH=`python -m site --user-site`/bin:\$PATH" >> ~/.bashrc
echo "export PYTHONPATH=$CODESPACE_VSCODE_FOLDER" >> ~/.bashrc
```

**Damit die Konfiguration aktiv wird, muss ein neues Terminal geöffnet werden.**

---

[← STARTSEITE](../README.md) |
[Prototyp ML-Experiment →](010_lab_initial_prototype.md)
