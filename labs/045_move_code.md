# Code verschieben

1. In der Datei `params.yaml` folgende Änderung durchführen:
    ```diff
    +base:
    +    log_level: INFO

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
1. Die Datei `src/utils.py` mit folgendem Inhalt erstellen:
    ```python
    import logging
    from typing import Text, Union
    import sys
    from pathlib import Path


    def use_file(path):
        _path = Path(path)
        _path.parent.mkdir(parents=True, exist_ok=True)
        return _path


    def get_console_handler() -> logging.StreamHandler:
        console_handler = logging.StreamHandler(sys.stdout)
        formatter = logging.Formatter(
            "%(asctime)s — %(name)s — %(levelname)s — %(message)s")
        console_handler.setFormatter(formatter)

        return console_handler


    def get_logger(name: Text = __name__, log_level: Union[Text, int] = logging.DEBUG) -> logging.Logger:
        logger = logging.getLogger(name)
        logger.setLevel(log_level)

        if logger.hasHandlers():
            logger.handlers.clear()

        logger.addHandler(get_console_handler())
        logger.propagate = False

        return logger
    ```

## Daten laden

1. Die Datei `src/data_load.py` mit folgendem Inhalt erstellen:
    ```python
    import argparse
    from sklearn import datasets, utils
    import yaml
    from typing import Text
    import joblib

    from src.utils import get_logger, use_file


    def data_load(config_path: Text) -> utils.Bunch:
        """Load raw data.
        Args:
            config_path {Text}: path to config
        """

        with open(config_path) as conf_file:
            config = yaml.safe_load(conf_file)

        logger = get_logger('data_load', log_level=config['base']['log_level'])

        logger.info('Get dataset')
        digits = datasets.load_digits()

        logger.info('Save raw data')
        joblib.dump(digits, use_file(config["data"]["dataset_joblib"]))

        return digits


    if __name__ == '__main__':

        args_parser = argparse.ArgumentParser()
        args_parser.add_argument('--config', dest='config', required=True)
        args = args_parser.parse_args()

        data_load(config_path=args.config)
    ```
1. Skript testen mit folgendem Befehl:
    ```shell
    python3 src/data_load.py --config params.yaml
    ```

### In einem Jupyter Notebook testen

1. Ein neues Jupyter Notebook `notebooks/pipline.ipynb` erstellen
1. Folgender Code in eine Zelle einfügen:
    ```python
    %load_ext autoreload
    %autoreload 2

    import os
    import sys
    from pathlib import Path

    # change directory one level up if current working directory is 'notebooks'
    if (Path.cwd().name == 'notebooks'):
        %cd ..
    ```
1. Folgender Code in eine weitere Zelle einfügen:
    ```python
    from src.data_load import data_load
    digits = data_load('params.yaml')
    ```
1. Oder direkt aus dem Notebook heraus wie auf der Kommandozeile:
    ```python
    !python3 src/data_load.py --config=params.yaml
    ```

## Daten vorbereiten

1. Die Datei `src/data_prepare.py` mit folgendem Inhalt erstellen:
    ```python
    import argparse
    import yaml
    from typing import Text
    import joblib
    import numpy as np
    import pandas as pd

    from src.utils import get_logger, use_file


    def data_prepare(config_path: Text) -> np.ndarray:
        """Prepare the data.
        Args:
            config_path {Text}: path to config
        """

        with open(config_path) as conf_file:
            config = yaml.safe_load(conf_file)

        logger = get_logger('data_prepare', log_level=config['base']['log_level'])

        logger.info('Load raw data')
        dataset = joblib.load(config["data"]["dataset_joblib"])

        logger.info('Prepare data')
        prepared_dataset = pd.DataFrame(
            data=np.c_[dataset.data, dataset.target], columns=dataset.feature_names + ['target'])

        logger.info('Save prepared data')
        prepared_dataset.to_csv(
            use_file(config["data"]["features_path"]), index=False)

        return prepared_dataset


    if __name__ == '__main__':

        args_parser = argparse.ArgumentParser()
        args_parser.add_argument('--config', dest='config', required=True)
        args = args_parser.parse_args()

        data_prepare(config_path=args.config)
    ```
1. Skript testen mit folgendem Befehl:
    ```shell
    python3 src/data_prepare.py --config params.yaml
    ```
1. Im Jupyter Notebook `notebooks/pipeline.ipynb` eine Zelle hinzufügen:
    ```shell
    !python3 src/data_prepare.py --config params.yaml
    ```

## Daten splitten

1. Die Datei `src/data_split.py` mit folgendem Inhalt erstellen:
    ```python
    import argparse
    import yaml
    from typing import Text
    import pandas as pd
    from sklearn.model_selection import train_test_split

    from src.utils import get_logger, use_file


    def data_split(config_path: Text) -> (pd.DataFrame, pd.DataFrame):
        """Split dataset.
        Args:
            config_path {Text}: path to config
        """

        with open(config_path) as conf_file:
            config = yaml.safe_load(conf_file)

        logger = get_logger('data_split', log_level=config['base']['log_level'])

        logger.info('Load features')
        data = pd.read_csv(config["data"]["features_path"])

        logger.info('Split data')
        train_dataset, test_dataset = train_test_split(
            data, test_size=config["data"]["test_size"], shuffle=False)

        logger.info('Save split data')
        train_dataset.to_csv(use_file(config["data"]["train_path"]), index=False)
        test_dataset.to_csv(use_file(config["data"]["test_path"]), index=False)

        return train_dataset, test_dataset


    if __name__ == '__main__':

        args_parser = argparse.ArgumentParser()
        args_parser.add_argument('--config', dest='config', required=True)
        args = args_parser.parse_args()

        data_split(config_path=args.config)
    ```
1. Skript testen mit folgendem Befehl:
    ```shell
    python3 src/data_split.py --config=params.yaml
    ```
1. Im Jupyter Notebook `notebooks/pipeline.ipynb` eine Zelle hinzufügen:
    ```shell
    !python3 src/data_split.py --config=params.yaml
    ```

## Training

1. Die Datei `src/train.py` mit folgendem Inhalt erstellen:
    ```python
    import argparse
    from sklearn import svm
    import yaml
    from typing import Text
    import joblib
    from pathlib import Path
    import pandas as pd

    from src.utils import get_logger, use_file


    def train_model(config_path: Text) -> any:
        """Train model.
        Args:
            config_path {Text}: path to config
        """

        with open(config_path) as conf_file:
            config = yaml.safe_load(conf_file)

        logger = get_logger('train_model', log_level=config['base']['log_level'])

        logger.info('Load train dataset')
        train_df = pd.read_csv(config["data"]["train_path"])
        X_train = train_df.drop('target', axis=1).values.astype('float32')
        y_train = train_df.loc[:, 'target'].values.astype('int32')

        logger.info('Train model')
        model = svm.SVC(kernel=config["train"]["svc_params"]
                        ["kernel"], C=config["train"]["svc_params"]["C"])
        model.fit(X_train, y_train)

        logger.info('Save model')
        joblib.dump(model, use_file(config["train"]["model_path"]))

        return model


    if __name__ == '__main__':

        args_parser = argparse.ArgumentParser()
        args_parser.add_argument('--config', dest='config', required=True)
        args = args_parser.parse_args()

        train_model(config_path=args.config)
    ```
1. Skript testen mit folgendem Befehl:
    ```shell
    python3 src/train.py --config=params.yaml
    ```
1. Im Jupyter Notebook `notebooks/pipeline.ipynb` eine Zelle hinzufügen:
    ```shell
    !python3 src/train.py --config=params.yaml
    ```
