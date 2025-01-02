#!/usr/bin/bash

echo "Starting jupyter notebook..."
source "$HOME/.venv/bin/activate"
python -m notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --notebook-dir=/home/jupyter/notebook