#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${PROJECT_DIR}/config.env"
PROFILE="${1:-bootstrap}"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Не найден ${CONFIG_FILE}"
  exit 1
fi

case "${PROFILE}" in
  bootstrap|1.5b|fast)
    alias_value="qwen2.5-1.5b-instruct-q4km"
    model_value="./models/qwen2.5-1.5b-instruct-q4_k_m.gguf"
    ;;
  recommended|7b)
    alias_value="qwen2.5-7b-instruct-q4km"
    model_value="./models/qwen2.5-7b-instruct-q4_k_m-00001-of-00002.gguf"
    ;;
  power|14b)
    alias_value="qwen2.5-14b-instruct-q4km"
    model_value="./models/qwen2.5-14b-instruct-q4_k_m-00001-of-00003.gguf"
    ;;
  *)
    echo "Использование: $0 {bootstrap|recommended|power}"
    exit 1
    ;;
esac

tmp_file="$(mktemp)"
CONFIG_FILE="${CONFIG_FILE}" \
TMP_FILE="${tmp_file}" \
ALIAS_VALUE="${alias_value}" \
MODEL_VALUE="${model_value}" \
python3 - <<'PY'
from pathlib import Path
import os

config_path = Path(os.environ["CONFIG_FILE"])
tmp_path = Path(os.environ["TMP_FILE"])
alias_value = os.environ["ALIAS_VALUE"]
model_value = os.environ["MODEL_VALUE"]

lines = config_path.read_text(encoding="utf-8").splitlines()
updated = []
seen_alias = False
seen_model = False

for line in lines:
    if line.startswith("MODEL_ALIAS="):
        updated.append(f'MODEL_ALIAS="{alias_value}"')
        seen_alias = True
    elif line.startswith("MODEL_FILE="):
        updated.append(f'MODEL_FILE="{model_value}"')
        seen_model = True
    else:
        updated.append(line)

if not seen_alias:
    updated.append(f'MODEL_ALIAS="{alias_value}"')
if not seen_model:
    updated.append(f'MODEL_FILE="{model_value}"')

tmp_path.write_text("\n".join(updated) + "\n", encoding="utf-8")
PY
mv "${tmp_file}" "${CONFIG_FILE}"

echo "Активный профиль переключен: ${PROFILE}"
echo "MODEL_ALIAS=${alias_value}"
echo "MODEL_FILE=${model_value}"
