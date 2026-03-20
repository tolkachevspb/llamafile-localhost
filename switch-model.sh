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
sed \
  -e "s|^MODEL_ALIAS=.*|MODEL_ALIAS=\"${alias_value}\"|" \
  -e "s|^MODEL_FILE=.*|MODEL_FILE=\"${model_value}\"|" \
  "${CONFIG_FILE}" > "${tmp_file}"
mv "${tmp_file}" "${CONFIG_FILE}"

echo "Активный профиль переключен: ${PROFILE}"
echo "MODEL_ALIAS=${alias_value}"
echo "MODEL_FILE=${model_value}"
