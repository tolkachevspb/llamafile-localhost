#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "${PROJECT_DIR}/config.env"

base_url="http://${HOST}:${PORT}"

echo "Проверяю UI: ${base_url}"
curl -fsS "${base_url}" >/dev/null
echo "OK: UI отвечает"

echo "Проверяю API: ${base_url}/v1/models"
curl -fsS "${base_url}/v1/models"
echo
