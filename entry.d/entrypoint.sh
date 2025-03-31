#!/bin/bash

set -x;

if [ -f /entry.d/requirements.txt ]; then
  pip install --no-cache-dir -r /entry.d/requirements.txt;
fi

for f in /entry.d/*.py; do
  python3 "$f"
done

tritonserver --model-repository=/models