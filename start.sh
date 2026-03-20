#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${PROJECT_DIR}/config.env"
PID_FILE="${PROJECT_DIR}/run/llamafile.pid"
LOG_FILE="${PROJECT_DIR}/logs/llamafile.log"
LLAMAFILE_BIN="${PROJECT_DIR}/bin/llamafile"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Не найден ${CONFIG_FILE}."
  echo "Скопируйте config.env.example в config.env или запустите ./bootstrap.sh"
  exit 1
fi

# shellcheck source=/dev/null
source "${CONFIG_FILE}"

resolve_path() {
  local raw="$1"
  if [[ -z "${raw}" ]]; then
    return 0
  fi
  if [[ "${raw}" = /* ]]; then
    printf '%s\n' "${raw}"
  else
    printf '%s\n' "${PROJECT_DIR}/${raw#./}"
  fi
}

MODEL_PATH="$(resolve_path "${MODEL_FILE}")"
SYSTEM_PROMPT_PATH="$(resolve_path "${SYSTEM_PROMPT_FILE:-}")"

if [[ ! -x "${LLAMAFILE_BIN}" ]]; then
  echo "Не найден исполняемый файл ${LLAMAFILE_BIN}."
  echo "Запустите ./bootstrap.sh для автоматической подготовки рантайма."
  exit 1
fi

if [[ ! -f "${MODEL_PATH}" ]]; then
  echo "Не найдена модель: ${MODEL_PATH}"
  echo "Проверьте загрузку в ${PROJECT_DIR}/models или запустите ./download-model.sh"
  exit 1
fi

mkdir -p "${PROJECT_DIR}/logs" "${PROJECT_DIR}/run"

if [[ -f "${PID_FILE}" ]]; then
  existing_pid="$(cat "${PID_FILE}")"
  if [[ -n "${existing_pid}" ]] && kill -0 "${existing_pid}" 2>/dev/null; then
    echo "llamafile уже запущен (PID ${existing_pid})."
    echo "UI:  http://${HOST}:${PORT}"
    echo "API: http://${HOST}:${PORT}/v1"
    exit 0
  fi
  rm -f "${PID_FILE}"
fi

cmd=(
  "${LLAMAFILE_BIN}"
  --server
  --nobrowser
  --host "${HOST}"
  --port "${PORT}"
  --alias "${MODEL_ALIAS}"
  -m "${MODEL_PATH}"
  -c "${CTX_SIZE}"
  -t "${THREADS}"
  -tb "${THREADS_BATCH}"
  -b "${BATCH_SIZE}"
  -np "${PARALLEL}"
  -to "${TIMEOUT}"
  -ngl "${GPU_LAYERS}"
)

if [[ -n "${SYSTEM_PROMPT_PATH}" ]]; then
  cmd+=(--system-prompt-file "${SYSTEM_PROMPT_PATH}")
fi

if [[ -n "${EXTRA_ARGS:-}" ]]; then
  # shellcheck disable=SC2206
  extra=( ${EXTRA_ARGS} )
  cmd+=("${extra[@]}")
fi

/usr/bin/python3 - "${PID_FILE}" "${LOG_FILE}" "${cmd[@]}" <<'PY'
import os
import shlex
import subprocess
import sys

pid_file = sys.argv[1]
log_file = sys.argv[2]
cmd = sys.argv[3:]
shell_cmd = "exec " + " ".join(shlex.quote(part) for part in cmd)

with open(log_file, "ab", buffering=0) as log_handle:
    process = subprocess.Popen(
        ["/bin/zsh", "-lc", shell_cmd],
        stdin=subprocess.DEVNULL,
        stdout=log_handle,
        stderr=log_handle,
        start_new_session=True,
        close_fds=True,
    )

with open(pid_file, "w", encoding="utf-8") as pid_handle:
    pid_handle.write(str(process.pid))
PY

echo "Запускаю llamafile (PID $(cat "${PID_FILE}"))..."

for _ in $(seq 1 60); do
  if curl -fsS "http://${HOST}:${PORT}/v1/models" >/dev/null 2>&1; then
    echo "Готово."
    echo "UI:  http://${HOST}:${PORT}"
    echo "API: http://${HOST}:${PORT}/v1"
    exit 0
  fi
  sleep 2
done

echo "Сервер не поднялся за ожидаемое время."
echo "См. лог: ${LOG_FILE}"
exit 1
