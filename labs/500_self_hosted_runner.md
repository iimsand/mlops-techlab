# Self-hosted Runner

**ACHTUNG:** Unter [Self-hosted runner security](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security) werden einige Risiken beschrieben wenn Self-hosted Runner benutzt werden.

**Es ist daher wichtig, dass das Repository `digits` NICHT ein public repository ist!**

Dies ist ersichtlich am Badge neben dem Repository Titel wenn man https://github.com/GITHUB_USER/digits aufruft.

## Voraussetzungen

- Linux
- Docker

## Self-hosted runner einrichten

Unter [Adding a self-hosted runner to a repository](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners#adding-a-self-hosted-runner-to-a-repository) wird beschrieben wie man einen self-hosted runner zu seinem repository hinzufügen kann.

Dazu auf dem **lokalen System** ein Terminal öffnen und folgende Befehle ausführen:

```shell
docker pull ubuntu:22.04
docker run --rm -it --name digits-runner ubuntu:22.04 /bin/bash

apt update -y && apt upgrade -y
apt install -y curl perl sudo python3-pip git

ln -s /usr/bin/python3 /usr/bin/python

adduser --disabled-password --gecos "" runner
usermod -aG sudo runner
echo 'runner ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/runner
sudo chmod 0440 /etc/sudoers.d/runner

su - runner

mkdir -p ./.local/bin
```

Nun https://github.com/GITHUB_USER/digits aufrufen und unter `Settings -> Actions -> Runners` oben rechts den Knopf `New self-hosted runner` klicken. Als Runner image `Linux` und Architecture `x64` wählen. In den nächsten aufgelisteten Schritten werden die Befehle benutzt, welche auf der Seite angezeigt werden.

```shell
# commands from https://github.com/GITHUB_USER/digits/settings/actions/runners/new
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.325.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.325.0.tar.gz
echo "5020da7139d85c776059f351e0de8fdec753affc9c558e892472d43ebeb518f4  actions-runner-linux-x64-2.325.0.tar.gz" | shasum -a 256 -c

# fehlende dependencies installieren
sudo ./bin/installdependencies.sh
```

Nun die Konfiguration.

```shell
# execute the .config command showed on https://github.com/GITHUB_USER/digits/settings/actions/runners/new with the token
# IMPORTANT: add additional tag 'cml' when asked! select default for all other options.

# execute `./run.sh`
```

Der runner ist nun bereit und es wird folgendes angezeigt:

```shell
runner@414a93e4dbc6:~/actions-runner$ ./run.sh

√ Connected to GitHub

Current runner version: '2.325.0'
2025-06-10 21:10:59Z: Listening for Jobs
```

Unter https://github.com/GITHUB_USER/digits/settings/actions/runners erscheint nun auch der Runner als _Idle_.

## Repository auf eigenen Runner umstellen

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
