#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT="${1:-Напиши короткое приветствие и подтвердите, что локальная модель отвечает.}"

# shellcheck source=/dev/null
source "${PROJECT_DIR}/config.env"

payload="$(PROMPT="${PROMPT}" MODEL_ALIAS="${MODEL_ALIAS}" python3 - <<'PY'
import json
import os

print(json.dumps({
    "model": os.environ["MODEL_ALIAS"],
    "messages": [
        {
            "role": "system",
            "content": "Ты локальная open-source модель в тестовом стенде на llamafile. Отвечай кратко по-русски.",
        },
        {
            "role": "user",
            "content": os.environ["PROMPT"],
        },
    ],
    "temperature": 0.2,
    "max_tokens": 220,
}, ensure_ascii=False))
PY
)"

curl -fsS "http://${HOST}:${PORT}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "${payload}"

echo
