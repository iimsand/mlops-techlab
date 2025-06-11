# Self-hosted Runner

**ACHTUNG:** Unter [Self-hosted runner security](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security) werden einige Risiken beschrieben wenn Self-hosted Runner benutzt werden.

**Es ist daher wichtig, dass das Repository `digits` NICHT ein public repository ist!**

Dies ist ersichtlich am Badge neben dem Repository Titel wenn man https://github.com/GITHUB_USER/digits aufruft.

## Voraussetzungen

- Linux
- Docker

## Self-hosted runner einrichten

Unter [Adding a self-hosted runner to a repository](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners#adding-a-self-hosted-runner-to-a-repository) wird beschrieben wie man einen self-hosted runner zu seinem repository hinzufügen kann.

Dazu auf dem **lokalen System** ein Projektverzeichnis (z.B. `self-hosted-runner`) erstellen und die Datei `Dockerfile` anlegen mit folgendem Inhalt:

```shell
FROM ubuntu:22.04

RUN apt update -y \
    && apt upgrade -y \
    && apt install -y curl perl sudo python3-pip git

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN adduser --disabled-password --gecos "" runner
RUN usermod -aG sudo runner
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/runner
RUN sudo chmod 0440 /etc/sudoers.d/runner

USER runner
WORKDIR /home/runner

RUN mkdir -p ./.local/bin
ENV PATH=/home/runner/.local/bin:${PATH}

# commands from https://github.com/GITHUB_USER/digits/settings/actions/runners/new
RUN mkdir actions-runner && cd actions-runner
RUN curl -o actions-runner-linux-x64-2.325.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.325.0.tar.gz
RUN echo "5020da7139d85c776059f351e0de8fdec753affc9c558e892472d43ebeb518f4  actions-runner-linux-x64-2.325.0.tar.gz" | shasum -a 256 -c

# fehlende dependencies installieren
RUN sudo ./bin/installdependencies.sh

```

Danach kann das Image lokal mit folgedem Befehl erstellt werden:

```shell
docker build -t local/self-hosted-runner:ubuntu-22.04 .
```

Den Container mit folgendem Befehl starten:

```shell
docker run -it --name self-hosted-runner local/self-hosted-runner:ubuntu-22.04 /bin/bash
```

Nun https://github.com/GITHUB_USER/digits aufrufen und unter `Settings -> Actions -> Runners` oben rechts den Knopf `New self-hosted runner` klicken. Als Runner image `Linux` und Architecture `x64` wählen. Der Befehl `./config` aus dem Abschnitt _Configuration_ aufrufen. Alle defaults übernehmen mit Ausname von `additional labels` - hier noch 'cml' als Label hinzufügen!

Die Ausgabe sollte wie folgt aussehen:

```shell
runner@1a8c73ec20fc:~$ ./config.sh --url https://github.com/iimsand/digits --token ***

--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------

# Authentication


√ Connected to GitHub

# Runner Registration

Enter the name of the runner group to add this runner to: [press Enter for Default] 

Enter the name of runner: [press Enter for 1a8c73ec20fc] 

This runner will have the following labels: 'self-hosted', 'Linux', 'X64' 
Enter any additional labels (ex. label-1,label-2): [press Enter to skip] cml

√ Runner successfully added
√ Runner connection is good

# Runner settings

Enter name of work folder: [press Enter for _work] 

√ Settings Saved.

runner@1a8c73ec20fc:~$ 
```

Runner nun mit `./run.sh` starten.

Der runner ist nun bereit und es wird folgendes angezeigt:

```shell
runner@1a8c73ec20fc:~$ ./run.sh

√ Connected to GitHub

Current runner version: '2.325.0'
2025-06-11 05:38:47Z: Listening for Jobs
```

Unter https://github.com/GITHUB_USER/digits/settings/actions/runners erscheint nun auch der Runner als _Idle_.

## Repository auf eigenen Runner umstellen

1. Wieder auf Codespaces im Browser wechseln.
1. Mit `git status` prüfen ob man auf dem `main` ist. Falls nicht, mit `git checkout main` auf diesen wechseln.
1. Datei `.github/workflows/cml.yaml` editieren und folgende Änderung durchführen:
    ```diff
    ...
    jobs:
      train-and-report:
    -   runs-on: ubuntu-22.04
    +   runs-on: [self-hosted, cml]
        steps:
        ...
    ```
1. Änderungen pushen mit:
    ```shell
    git add .
    git commit -m "Use self-hosted runner."
    git push
    ```

Nun führen wir ein Experiment durch wie wir das schon kennen:

1. Einen neuen Branch erstellen mit:
    ```shell
    git checkout -b my-exp
    git push --set-upstream origin my-exp
    ```
1. In der Datei `params.yaml` einen Parameter ändern und die Datei speichern.
1. Änderungen pushen mit:
    ```shell
    git add .
    git commit -m "My experiment."
    git push
    dvc push
    ```
1. Unter https://github.com/GITHUB_USER/digits/actions wird wieder ein Workflow ausgeführt. Dieser workflow wird nun aber auf dem self-hosted runner lokal ausgeführt.

## Container erneut starten

Wurde der Container gestoppt und man will ihn erneut starten, kann man dies wie folgt erreichen:

```shell
docker start self-hosted-runner
docker exec -it self-hosted-runner ./run.sh
```
