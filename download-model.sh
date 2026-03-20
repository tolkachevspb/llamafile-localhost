#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="${PROJECT_DIR}/models"
PROFILE="${1:-recommended}"

mkdir -p "${MODELS_DIR}"

download() {
  local url="$1"
  local dest="$2"
  echo "Скачиваю $(basename "${dest}")"
  curl -fL -C - --progress-bar -o "${dest}" "${url}"
}

case "${PROFILE}" in
  bootstrap|1.5b|fast)
    download \
      "https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-1.5b-instruct-q4_k_m.gguf"
    ;;
  recommended|7b)
    download \
      "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF/resolve/main/qwen2.5-7b-instruct-q4_k_m-00001-of-00002.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-7b-instruct-q4_k_m-00001-of-00002.gguf"
    download \
      "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF/resolve/main/qwen2.5-7b-instruct-q4_k_m-00002-of-00002.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-7b-instruct-q4_k_m-00002-of-00002.gguf"
    ;;
  power|14b)
    download \
      "https://huggingface.co/Qwen/Qwen2.5-14B-Instruct-GGUF/resolve/main/qwen2.5-14b-instruct-q4_k_m-00001-of-00003.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-14b-instruct-q4_k_m-00001-of-00003.gguf"
    download \
      "https://huggingface.co/Qwen/Qwen2.5-14B-Instruct-GGUF/resolve/main/qwen2.5-14b-instruct-q4_k_m-00002-of-00003.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-14b-instruct-q4_k_m-00002-of-00003.gguf"
    download \
      "https://huggingface.co/Qwen/Qwen2.5-14B-Instruct-GGUF/resolve/main/qwen2.5-14b-instruct-q4_k_m-00003-of-00003.gguf?download=true" \
      "${MODELS_DIR}/qwen2.5-14b-instruct-q4_k_m-00003-of-00003.gguf"
    ;;
  *)
    echo "Использование: $0 {bootstrap|recommended|power}"
    exit 1
    ;;
esac

echo "Готово."
