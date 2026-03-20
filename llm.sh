#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION="${1:-start}"

case "${ACTION}" in
  start)
    exec "${PROJECT_DIR}/start.sh"
    ;;
  stop)
    exec "${PROJECT_DIR}/stop.sh"
    ;;
  restart)
    "${PROJECT_DIR}/stop.sh" || true
    exec "${PROJECT_DIR}/start.sh"
    ;;
  health)
    exec "${PROJECT_DIR}/healthcheck.sh"
    ;;
  test)
    shift || true
    exec "${PROJECT_DIR}/prompt-test.sh" "${@:-}"
    ;;
  download)
    shift || true
    exec "${PROJECT_DIR}/download-model.sh" "${1:-recommended}"
    ;;
  use-bootstrap)
    exec "${PROJECT_DIR}/switch-model.sh" bootstrap
    ;;
  use-7b)
    exec "${PROJECT_DIR}/switch-model.sh" recommended
    ;;
  use-14b)
    exec "${PROJECT_DIR}/switch-model.sh" power
    ;;
  logs)
    exec tail -n 50 -f "${PROJECT_DIR}/logs/llamafile.log"
    ;;
  status)
    if [[ -f "${PROJECT_DIR}/run/llamafile.pid" ]] && kill -0 "$(cat "${PROJECT_DIR}/run/llamafile.pid")" 2>/dev/null; then
      echo "Запущен: PID $(cat "${PROJECT_DIR}/run/llamafile.pid")"
    else
      echo "Не запущен"
    fi
    ;;
  open)
    # Для локального использования на macOS.
    # shellcheck source=/dev/null
    source "${PROJECT_DIR}/config.env"
    exec open "http://${HOST}:${PORT}"
    ;;
  *)
    echo "Использование: $0 {start|stop|restart|status|health|test|download|use-bootstrap|use-7b|use-14b|logs|open}"
    exit 1
    ;;
esac
