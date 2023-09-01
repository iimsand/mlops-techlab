# Systemvoraussetzungen

Das Lab kann vollständig mit GitHub-Codespaces druchgeführt werden. Dafür bauchst du einen GitHub-Account.

Für den letzten optionalen Schritt brauchst du zusätzlich Docker. Alle nötigen Informationen sind in der Anleitung dieses Schritts festgehalten. 

Alternativ kann eine lokale Python- und GIT-Installation verwendet werden. Eine detailierte Instellationsanleitung befindet sich im Kapitel [Lokale Umgebung aufsetzen](#lokale-umgebung-aufsetzen)

### GitHub-Repository
Dieses Repository ist schreibgeschützt. Damit du selber anpacken kannst, musst du eine Fork erstellen.


### GitHub-Codespace
Aus deinem geforkten Repository kannst du nun GitHub-Codespaces öffnen.

### Erweiterungen für Visual Stuido Code laden

Um optimal arbeiten zu können, installieren wir ein paar VSC-Erweiterungen.

```shell
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension Iterative.vscode-dvc-pack
```

### Virtuelle Umgebung für Python erstellen

Damit wir sicher die richtige Version der Python-Erweiterungen geladen haben, erstellen wir eine virutelle Umgebung. So können wir in unterschiedlichen Python-Projekten verschiedenen Versiobnen der Python-Erweiterungen nutzen. Siehe auch: https://docs.python.org/3/library/venv.html

```shell
python3 -m venv .env
echo "export PYTHONPATH=$PWD" >> .env/bin/activate

source .env/bin/activate

pip install --upgrade pip setuptools
pip install -r requirements.txt
```

Die VSC-Erweiterungen und das Aufsetzen der virtellen Umgebung ist im `init.sh` zusammengefasst.

```shell
./init.sh
```

Da dieses Repository schreibgeschützt ist, müssen wir uns einen Fork davon erstellen.


## Lokale Umgebung aufsetzen
Wir empfehlen Visual Studio Code als Entwicklungsubebung. Untenstehende Anleitung beschreibt die Schritte, um die Voraussetzungen in einer Linux-Umbebung bereitzustellen

### Python

```shell
sudo apt-get update
sudo apt-get install python3 python3-pip python3.8-venv
```

### Git

```shell
sudo apt-get install git
```

### Visual Studio Code

Die offizielle Installationsanleitung ist unter https://code.visualstudio.com/docs/setup/linux zu finden.

Die folgenden Schritte werden darin beschrieben:

```shell
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg