# Umgebung vorbereiten

Das Lab kann vollständig mit GitHub-Codespaces druchgeführt werden. Dafür bauchst du einen GitHub-Account.

Alternativ kann eine lokale Python- und Git-Installation verwendet werden. Eine detaillierte Installationsanleitung befindet sich im Kapitel [Lokale Umgebung aufsetzen](#lokale-umgebung-aufsetzen) weiter unten.

## GitHub-Repository

$\colorbox{yellow}{{\color{gray}{TODO}}}$ _Template Repository mit Lösungen erstellen. Hier erklären wie man sein eigenes Repository vom Template erstellt._

Dieses Repository ist schreibgeschützt. Damit du selber anpacken kannst, musst du einen Fork erstellen.

https://docs.github.com/en/get-started/quickstart/fork-a-repo

## GitHub-Codespace

Aus deinem geforkten Repository kannst du nun GitHub-Codespaces öffnen.

https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace-for-a-repository

## Erweiterungen für Visual Studio Code laden

Um optimal arbeiten zu können, installieren wir ein paar VSC-Erweiterungen.

```shell
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension Iterative.vscode-dvc-pack
```

## Virtuelle Umgebung für Python erstellen

Damit wir sicher die richtige Version der Python-Erweiterungen geladen haben, erstellen wir eine virutelle Umgebung. So können wir in unterschiedlichen Python-Projekten verschiedenen Versionen der Python-Erweiterungen nutzen. Siehe auch: https://docs.python.org/3/library/venv.html

Wenn du GitHub-Codespaces verwendest, ist eine virtuelle Umgebung nicht zwingend nötig. Das `requirements.txt` File wird beim Start des Codespaces automatisch geladen. Für die lokale Entwicklung ist die virtuelle Umgebung aber wärmstens zu empfehlen!

```shell
python3 -m venv .env
echo "export PYTHONPATH=$PWD" >> .env/bin/activate

# muss jedesmal nach dem Öffnen des Terminals ausgeführt werden
# danach erscheint (.env) am Anfang der Zeile
source .env/bin/activate

pip install --upgrade pip setuptools
pip install -r requirements.txt
```

## Lokale Umgebung aufsetzen

Dieses Kapitel musst du nur beachten, falls du das Lab in deiner lokalen Umgebung durchspielen möchtest. Wenn du Codespaces nutzt, kannst du dieses Kapitel komplett ignorieren.

Wir empfehlen Visual Studio Code als Entwicklungsumgebung. Die untenstehende Anleitung beschreibt die Schritte, um die Voraussetzungen in einer Linux-Umgebung bereitzustellen.

### Git

```shell
sudo apt-get install git
```

### Python

```shell
sudo apt-get update
sudo apt-get install python3 python3-pip python3.8-venv
```

Nun kannst du die virtuelle Pyhon Umgebung wie unter [Virtuelle Umgebung für Python erstellen](#virtuelle-umgebung-für-python-erstellen) beschrieben, erstellen.

### Visual Studio Code

Die offizielle Installationsanleitung ist unter https://code.visualstudio.com/docs/setup/linux zu finden.

Die folgenden Schritte werden darin beschrieben:

```shell
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Update the package cache and install Visuall Studio Code
sudo apt install apt-transport-https
sudo apt update
sudo apt install code
```

Nun solltest du noch die Erweiterungen wie unter [Erweiterungen für Visual Studio Code laden](#erweiterungen-für-visual-studio-code-laden) beschrieben, installieren.

### Docker

Die offizielle Installationsanleitung ist unter https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository zu finden.

Die folgenden Schritte werden darin beschrieben:

```shell
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# Add Docker’s official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index:
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose.
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create the docker group.
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER
```

Am besten das System neu starten damit alle Änderungen übernommen werden.

Testen das `docker` funktioniert:

```shell
docker run hello-world
```
