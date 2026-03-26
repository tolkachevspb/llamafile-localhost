#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${PROJECT_DIR}/bin"
LLAMAFILE_BIN="${BIN_DIR}/llamafile"
PROFILE="${1:-bootstrap}"

require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Не найдена команда: ${cmd}"
    exit 1
  fi
}

for cmd in curl git python3 uname; do
  require_cmd "${cmd}"
done

os_name="$(uname -s)"
arch="$(uname -m)"

if [[ "${os_name}" != "Darwin" ]]; then
  echo "Этот проект рассчитан только на macOS. Обнаружено: ${os_name}"
  exit 1
fi

if [[ "${arch}" != "arm64" ]]; then
  echo "Этот проект рассчитан только на macOS Apple Silicon (arm64). Обнаружено: ${arch}"
  exit 1
fi

mkdir -p "${PROJECT_DIR}/bin" "${PROJECT_DIR}/models" "${PROJECT_DIR}/logs" "${PROJECT_DIR}/run" "${PROJECT_DIR}/downloads"

if [[ ! -f "${PROJECT_DIR}/config.env" ]]; then
  cp "${PROJECT_DIR}/config.env.example" "${PROJECT_DIR}/config.env"
  echo "Создан config.env из config.env.example"
fi

if [[ ! -x "${LLAMAFILE_BIN}" ]]; then
  echo "Скачиваю llamafile v0.9.3"
  curl -fL --progress-bar -o "${LLAMAFILE_BIN}" \
    "https://github.com/mozilla-ai/llamafile/releases/download/0.9.3/llamafile-0.9.3"
  chmod +x "${LLAMAFILE_BIN}"
fi

case "${PROFILE}" in
  bootstrap|1.5b|fast)
    "${PROJECT_DIR}/switch-model.sh" bootstrap
    ;;
  recommended|7b)
    "${PROJECT_DIR}/switch-model.sh" recommended
    ;;
  power|14b)
    "${PROJECT_DIR}/switch-model.sh" power
    ;;
  *)
    echo "Использование: $0 {bootstrap|recommended|power}"
    exit 1
    ;;
esac

"${PROJECT_DIR}/download-model.sh" "${PROFILE}"

echo
echo "Bootstrap завершен."
echo "Дальше:"
echo "  cd ${PROJECT_DIR}"
echo "  ./llm.sh start"
echo "  ./llm.sh open"
