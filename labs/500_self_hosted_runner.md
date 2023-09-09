# Self-hosted Runner

**ACHTUNG:** Unter [Self-hosted runner security](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners#self-hosted-runner-security) werden einige Risiken beschrieben wenn Self-hosted Runner benutzt werden.

**Es ist daher wichtig, dass das Repository `digits` NICHT ein public repository ist!**

Dies ist ersichtlich am Badge neben dem Repository Titel wenn man https://github.com/GITHUB_USER/digits aufruft.

## GitHub Access token erstellen

1. Aufrufen von https://github.com/settings/tokens und _Generate new token (classic)_ wählen.
1. Für das neue Token folgende Werte verwenden:
    - Note: `PERSONAL_ACCESS_TOKEN`
    - Scopes: `repo` (Full control of private repositories)
1. Klick auf _Generate token_
1. Token kopieren und irgendwo sicher ablegen (z.B. KeePass)

## Runner starten

1. Neues Terminal öffnen.
1. `repo_url` setzen wie folgt (`GITHUB_USER` ersetzen mit eigenem GitHub Benutzer!):
    ```shell
    export repo_url=https://github.com/GITHUB_USER/digits.git
    ```
1. `repo_token` setzen wie folgt (`TOKEN` ersetzen mit oben generiertem Token!):
    ```shell
    export repo_token=TOKEN
    ```
1. Den Runner mit folgendem Befehl starten:
    ```shell
    docker run \
        --name digits-runner \
        -d \
        -e RUNNER_IDLE_TIMEOUT=1800 \
        -e RUNNER_LABELS=cml \
        -e RUNNER_REPO=$repo_url \
        -e REPO_TOKEN=$repo_token \
        iterativeai/cml:0-dvc3-base1 \
        cml runner --
    ```
1. Logs ausgeben mit:
    ```shell
    docker logs -f digits-runner
    ```
1. Unter https://github.com/GITHUB_USER/digits/settings/actions/runners erscheint nach einiger Zeit der Runner als _Idle_.

## Repository auf eigenen Runner umstellen

1. Mit `git status` prüfen ob man auf dem `main` ist. Falls nicht, mit `git checkout main` auf diesen wechseln.
1. Datei `.github/workflows/cml.yaml` editieren und folgende Änderung durchführen:
    ```diff
    ...
    jobs:
      train-and-report:
    -   runs-on: ubuntu-latest
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
1. Nach kurzer Zeit sieht man im Log des Runners, das der Job gestartet wurde:
    ```
    {"date":"2023-08-13T17:09:46.606Z","level":"info","message":"runner status","repo":"https://github.com/GITHUB_USER/digits","status":"job_started"}
    ```
1. Unter https://github.com/GITHUB_USER/digits/actions kann der aktuelle Stand des Jobs eingesehen werden.
1. Ist der Job beendet, sieht man im Log des Runners auch die folgende Zeile:
    ```
    {"date":"2023-08-13T17:10:47.154Z","level":"info","message":"runner status","repo":"https://github.com/GITHUB_USER/digits","status":"job_ended","success":true}
    ```
