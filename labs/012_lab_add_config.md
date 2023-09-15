# Konfiguration hinzufügen

**Dieses Lab wird im Workshop vorgestellt und zusammen durchgegangen. Daher kannst du dieses Lab ignorieren. Springe bitte direkt zum nächsten Lab [Pipeline zusammenstellen →](020_lab_init_pipeline.md)**

Damit wir später nicht ständig Anpassungen im Code duchführen müssen, extrahieren wir die Informationen in eine Konfigurationsdatei.

1. Die Datei `params.yaml` mit folgendem Inhalt erstellen:
    ```yaml
    data:
        dataset_joblib: data/raw/data_digits.joblib
        features_path: data/processed/digits.csv
        test_size: 0.5
        train_path: data/train/train.csv
        test_path: data/test/test.csv
    train:
        svc_params:
            kernel: linear
            C: 0.025
        model_path: models/model.joblib

    reports:
        metrics_path: reports/metrics.json
        cm_plot_path: reports/confusion_matrix.png
    ```
1. Folgende Änderungen im Code durchführen:
    ```diff
    import matplotlib.pyplot as plt

    from sklearn import datasets, metrics, svm
    from sklearn.model_selection import train_test_split
    import pandas as pd
    import numpy as np

    import joblib
    import json
    from pathlib import Path

    +import yaml
    +import pprint

    # change directory one level up if current working directory is 'notebooks'
    if (Path.cwd().name == 'notebooks'):
        %cd ..

    def use_file(path):
        _path = Path(path)
        _path.parent.mkdir(parents=True, exist_ok=True)
        return _path


    +# load config
    +with open('params.yaml') as conf_file:
    +    config = yaml.safe_load(conf_file)
    +pprint.pprint(config)


    # get
    digits = datasets.load_digits()

    -joblib.dump(digits, use_file("data/raw/data_digits.joblib"))
    +joblib.dump(digits, use_file(config["data"]["dataset_joblib"]))

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

    -prepared_dataset.to_csv(use_file("data/processed/digits.csv"), index=False)
    +prepared_dataset.to_csv(use_file(config["data"]["features_path"]), index=False)

    # split
    -train_dataset, test_dataset = train_test_split(prepared_dataset, test_size=0.5, shuffle=False)
    +train_dataset, test_dataset = train_test_split(prepared_dataset, test_size=config["data"]["test_size"], shuffle=False)

    -train_dataset.to_csv(use_file("data/train/train.csv"), index=False)
    -test_dataset.to_csv(use_file("data/test/test.csv"), index=False)
    +train_dataset.to_csv(use_file(config["data"]["train_path"]), index=False)
    +test_dataset.to_csv(use_file(config["data"]["test_path"]), index=False)

    # train
    X_train = train_dataset.drop('target', axis=1).values
    y_train = train_dataset.loc[:, 'target'].values

    -model = svm.SVC(kernel="linear", C=0.025)
    +model = svm.SVC(kernel=config["train"]["svc_params"]["kernel"], C=config["train"]["svc_params"]["C"])
    model.fit(X_train, y_train)

    -joblib.dump(model, use_file("models/model.joblib"))
    +joblib.dump(model, use_file(config["train"]["model_path"]))

    # evaluate
    X_test = test_dataset.drop('target', axis=1).values
    y_test = test_dataset.loc[:, 'target'].values

    predicted = model.predict(X_test)

    f1 = metrics.f1_score(y_test, predicted, average="macro")
    print(f"f1 score: {f1}")

    json_metrics = { 'f1': f1 }
    -with open(use_file("reports/metrics.json"), "w") as metrics_file:
    +with open(use_file(config["reports"]["metrics_path"]), "w") as metrics_file:
        json.dump(obj=json_metrics, fp=metrics_file, indent=4)

    cm_plot = metrics.ConfusionMatrixDisplay.from_predictions(y_test, predicted)
    cm_plot.figure_.suptitle("Confusion Matrix")
    plt.show()

    -cm_plot.figure_.savefig(use_file("reports/confusion_matrix.png"))
    +cm_plot.figure_.savefig(use_file(config["reports"]["cm_plot_path"]))
    ```
1. Testen ob noch alles funktoniert
1. Die erstellten Dateien auf GitHub übertragen:
    ```shell
    git add .
    git commit -m "Add configuration."
    git push
    ```

---
