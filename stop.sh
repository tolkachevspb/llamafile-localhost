#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="${PROJECT_DIR}/run/llamafile.pid"

if [[ ! -f "${PID_FILE}" ]]; then
  echo "PID-файл не найден. Похоже, сервер уже остановлен."
  exit 0
fi

pid="$(cat "${PID_FILE}")"

if [[ -z "${pid}" ]]; then
  rm -f "${PID_FILE}"
  echo "PID-файл был пустым, удалил его."
  exit 0
fi

if kill -0 "${pid}" 2>/dev/null; then
  kill "${pid}"
  for _ in $(seq 1 20); do
    if ! kill -0 "${pid}" 2>/dev/null; then
      rm -f "${PID_FILE}"
      echo "llamafile остановлен."
      exit 0
    fi
    sleep 1
  done
  kill -9 "${pid}" 2>/dev/null || true
fi

rm -f "${PID_FILE}"
echo "llamafile остановлен."
