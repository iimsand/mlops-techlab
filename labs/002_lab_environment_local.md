# Lokale Umgebung aufsetzen

**ACHTUNG: Wenn du Codespaces nutzt, ist dieses Kapitel für dich NICHT relevant und muss komplett übersprungen werden!**

Dieses Kapitel musst du nur beachten, falls du das Lab in deiner lokalen Umgebung durchspielen möchtest.

Wir empfehlen Visual Studio Code als Entwicklungsumgebung. Die untenstehende Anleitung beschreibt die Schritte, um die Voraussetzungen in einer Linux-Umgebung bereitzustellen.

## Voraussetzungen

- Linux (die Installation und das Lab wurden mit Ubuntu 20.04 LTS getestet)

## Git

```shell
sudo apt-get install git
```

## Python

```shell
sudo apt-get update
sudo apt-get install python3 python3-pip python3.8-venv
```

## Virtuelle Umgebung für Python erstellen

Damit wir sicher die richtige Version der Python-Erweiterungen geladen haben, erstellen wir eine virtuelle Umgebung. So können wir in unterschiedlichen Python-Projekten verschiedene Versionen der Python-Erweiterungen nutzen. Siehe auch: https://docs.python.org/3/library/venv.html

**Für die lokale Entwicklung ist die virtuelle Umgebung wärmstens zu empfehlen!**

```shell
python3 -m venv .env
echo "export PYTHONPATH=$PWD" >> .env/bin/activate

# muss jedesmal nach dem Öffnen des Terminals ausgeführt werden
# danach erscheint (.env) am Anfang der Zeile
source .env/bin/activate

pip install --upgrade pip setuptools
pip install -r requirements.txt
```Dieses Kapitel musst du nur beachten, falls du das Lab in deiner lokalen Umgebung durchspielen möchtest.


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

### Visual Studio Code - Erweiterungen

Um optimal arbeiten zu können, installieren wir noch ein paar Erweiterungen.

```shell
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension Iterative.vscode-dvc-pack
```

## Docker

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

---

[← Umgebung vorbereiten](001_lab_environment.md) | [STARTSEITE](../README.md) |
[Prototyp ML-Experiment →](010_lab_initial_prototype.md)
