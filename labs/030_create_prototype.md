# Prototyp erstellen

1. In das Projektverzeichnis `digits` wechseln
1. VCode im Projektverzeichnis starten:
    ```shell
    code .
    ```
1. Die Datei `.gitignore` mit folgendem Inhalt erstellen:
    ```
    /.env
    .ipynb_checkpoints/
    __pycache__/
    /.vscode
    ```
1. Die Datei `requirements.txt` mit folgendem Inhalt erstellen:
    ```
    scikit-learn==1.3.0
    matplotlib==3.7.2
    pandas==2.0.3
    jupyterlab==4.0.3
    ```
1. Ein neues Terminal in VSCode öffnen.
1. Mit den folgenden Befehlen wird eine virtuelle Python Umgebung erstellt:
    ```shell
    python3 -m venv .env
    echo "export PYTHONPATH=$PWD" >> .env/bin/activate

    source .env/bin/activate

    pip install --upgrade pip setuptools
    pip install -r requirements.txt

    python3 -m ipykernel install --user --name=digits
    ```
1. Ein Verzeichnis `notebooks` erstellen.
1. Eine neue Datei `prototype.ipynb` im Verzeichnis `notebooks` erstellen.
1. Die Datei `prototype.ipynb` mit einem Doppelklick öffnen.
1. Die erstellte Python Umgebung wie folgt konfigurieren:
    1. Oben rechts _Select Kernel_ wählen.   
        ![](screenshots/vscode-select-kernel-00.png)
    1. Im Menü _Python Environments..._ klicken:   
        ![](screenshots/vscode-select-kernel-01.png)
    1. Das vorher erstellte Environment `.env` auswählen:
        ![](screenshots/vscode-select-kernel-02.png)
1. Nun kann der folgende Code eingefügt und ausgeführt werden:
    ```diff
    import matplotlib.pyplot as plt

    from sklearn import datasets, metrics, svm
    from sklearn.model_selection import train_test_split
    import pandas as pd
    import numpy as np


    # get
    digits = datasets.load_digits()

    # explore
    _, axes = plt.subplots(nrows=1, ncols=4, figsize=(10, 3))
    for ax, image, label in zip(axes, digits.images, digits.target):
        ax.set_axis_off()
        ax.imshow(image, cmap=plt.cm.gray_r, interpolation="nearest")
        ax.set_title("label: %i" % label)

    # prepare
    n_samples = len(digits.images)
    data = digits.images.reshape((n_samples, -1))
    prepared_dataset = pd.DataFrame(data=np.c_[data, digits.target], columns=digits.feature_names + ['target'])

    # split
    train_dataset, test_dataset = train_test_split(prepared_dataset, test_size=0.5, shuffle=False)

    # train
    X_train = train_dataset.drop('target', axis=1).values
    y_train = train_dataset.loc[:, 'target'].values

    model = svm.SVC(kernel="linear", C=0.025)
    model.fit(X_train, y_train)

    # evaluate
    X_test = test_dataset.drop('target', axis=1).values
    y_test = test_dataset.loc[:, 'target'].values

    predicted = model.predict(X_test)

    f1 = metrics.f1_score(y_test, predicted, average="macro")
    print(f"f1 score: {f1}")

    cm_plot = metrics.ConfusionMatrixDisplay.from_predictions(y_test, predicted)
    cm_plot.figure_.suptitle("Confusion Matrix")
    plt.show()
    ```
1. Die erstellten Dateien auf GitHub übertragen:
    ```shell
    git add .
    git commit -m "Add prototype notebook."
    git push
    ```

## Zusätzliche Dokumentation

- [Recognizing hand-written digits](https://scikit-learn.org/stable/auto_examples/classification/plot_digits_classification.html)
