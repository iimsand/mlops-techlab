# Visual Studio Code extensions installieren
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension Iterative.vscode-dvc-pack

# Python Virtual Environment erstellen
python3 -m venv .env
echo "export PYTHONPATH=$PWD" >> .env/bin/activate

source .env/bin/activate

pip install --upgrade pip setuptools
pip install -r requirements.txt
