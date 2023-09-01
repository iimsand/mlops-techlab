python3 src/data_load.py --config params.yaml
python3 src/data_prepare.py --config params.yaml
python3 src/data_split.py --config params.yaml
python3 src/train.py --config params.yaml
python3 src/evaluate.py --config params.yaml