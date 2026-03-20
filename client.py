#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path
import sys
import urllib.error
import urllib.request
from typing import Any, Dict, Optional


PROJECT_DIR = Path(__file__).resolve().parent


def load_project_config() -> Dict[str, str]:
    config_path = PROJECT_DIR / "config.env"
    data: Dict[str, str] = {}
    if not config_path.exists():
        return data

    for raw_line in config_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip().strip('"').strip("'")
    return data


def build_payload(model: str, prompt: str, system_prompt: Optional[str], temperature: float, max_tokens: int) -> bytes:
    messages = []
    if system_prompt:
        messages.append({"role": "system", "content": system_prompt})
    messages.append({"role": "user", "content": prompt})
    payload = {
        "model": model,
        "messages": messages,
        "temperature": temperature,
        "max_tokens": max_tokens,
    }
    return json.dumps(payload).encode("utf-8")


def chat(base_url: str, api_key: str, model: str, prompt: str, system_prompt: Optional[str], temperature: float, max_tokens: int) -> Dict[str, Any]:
    endpoint = f"{base_url.rstrip('/')}/v1/chat/completions"
    data = build_payload(model, prompt, system_prompt, temperature, max_tokens)
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}",
    }
    request = urllib.request.Request(endpoint, data=data, headers=headers, method="POST")
    with urllib.request.urlopen(request, timeout=180) as response:
        return json.loads(response.read().decode("utf-8"))


def main() -> int:
    project_config = load_project_config()

    parser = argparse.ArgumentParser(description="Минимальный Python-клиент для локального llamafile API.")
    parser.add_argument("prompt", help="Промпт для модели")
    parser.add_argument("--model", default=os.getenv("AI_MODEL", project_config.get("MODEL_ALIAS", "qwen2.5-1.5b-instruct-q4km")))
    parser.add_argument("--base-url", default=os.getenv("AI_BASE_URL", f"http://{project_config.get('HOST', '127.0.0.1')}:{project_config.get('PORT', '8080')}"))
    parser.add_argument("--api-key", default=os.getenv("AI_API_KEY", "local"))
    parser.add_argument("--system", default=os.getenv("AI_SYSTEM_PROMPT", "Ты помогаешь тестировать локальный AI-стек."))
    parser.add_argument("--temperature", type=float, default=0.2)
    parser.add_argument("--max-tokens", type=int, default=320)
    args = parser.parse_args()

    try:
        response = chat(
            base_url=args.base_url,
            api_key=args.api_key,
            model=args.model,
            prompt=args.prompt,
            system_prompt=args.system,
            temperature=args.temperature,
            max_tokens=args.max_tokens,
        )
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        print(f"HTTP error {exc.code}: {body}", file=sys.stderr)
        return 1
    except urllib.error.URLError as exc:
        print(f"Network error: {exc}", file=sys.stderr)
        return 1

    print(json.dumps(response, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
