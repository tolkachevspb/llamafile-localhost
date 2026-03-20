# SMOKE TEST RESULT

Дата проверки: 2026-03-20

Статус: успешно

## Что проверено

### 1. Запуск модели

- Команда: `./start.sh`
- Результат: сервер успешно поднялся
- UI: `http://127.0.0.1:8080`
- API: `http://127.0.0.1:8080/v1`

### 2. Проверка web UI

- Команда: `curl -fsS http://127.0.0.1:8080 | head -n 5`
- Результат: корневая HTML-страница встроенного интерфейса отдается корректно

### 3. Проверка API

- Команда: `./healthcheck.sh`
- Результат:

```json
{"data":[{"created":1774004838,"id":"qwen2.5-1.5b-instruct-q4km","object":"model","owned_by":"llamacpp"}],"object":"list"}
```

### 4. Тестовый prompt через shell-скрипт

- Команда: `./prompt-test.sh 'Коротко подтвердите, что локальная модель отвечает через llamafile.'`
- Результат:

```json
{"choices":[{"finish_reason":"stop","index":0,"message":{"content":"Да, теперь я отвечаю как рекомендуемый 7B-профиль.","role":"assistant"}}],"created":1774016925,"id":"chatcmpl-eVgO4gvdRhMy8btYqaISH2XE9IZncxdp","model":"qwen2.5-7b-instruct-q4km","object":"chat.completion","usage":{"completion_tokens":25,"prompt_tokens":69,"total_tokens":94}}
```

### 5. Тестовый prompt через Python-клиент

- Команда: `python3 client.py 'Ответь одним коротким предложением: локальный стек работает.'`
- Результат:

```json
{
  "choices": [
    {
      "finish_reason": "stop",
      "index": 0,
      "message": {
        "content": "Основной 7B-профиль работает корректно.",
        "role": "assistant"
      }
    }
  ],
  "created": 1774017371,
  "id": "chatcmpl-sHjUwBE1eYCSy9BjQmcpHlfN0jqN7tj3",
  "model": "qwen2.5-7b-instruct-q4km",
  "object": "chat.completion",
  "usage": {
    "completion_tokens": 15,
    "prompt_tokens": 51,
    "total_tokens": 66
  }
}
```

## Активный профиль после smoke test

- Runtime: `llamafile v0.9.3`
- Активная модель: `Qwen2.5-7B-Instruct Q4_K_M`
- Статус: основной рабочий профиль успешно запущен и проверен
- Bootstrap-профиль остается доступным через `./switch-model.sh bootstrap`
