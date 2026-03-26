# Локальный AI-стек на `llamafile` для macOS Apple Silicon

> Локальный open-source LLM-стек для macOS Apple Silicon с `llamafile`, browser UI, OpenAI-compatible API, HTML-документацией и готовым bootstrap-потоком.

![Platform](https://img.shields.io/badge/platform-macOS%20Apple%20Silicon-1f6f66)
![Runtime](https://img.shields.io/badge/runtime-llamafile%20v0.9.3-b44725)
![API](https://img.shields.io/badge/API-OpenAI%20compatible-c69219)
![Profile](https://img.shields.io/badge/default_profile-Qwen2.5%207B-2e2a24)

## Why This Repo Exists

Этот репозиторий существует для очень практичной задачи: быстро поднять локальную open-source LLM на macOS Apple Silicon без Docker-оркестрации, без тяжелой инфраструктуры и без длинной ручной настройки.

Здесь уже собраны:

- bootstrap-сценарий для первого запуска
- локальный browser UI
- OpenAI-compatible API
- переключение между легким и рабочим профилем модели
- HTML-страницы с обзором проекта и шпаргалкой
- база для локальных agent PoC, включая сценарии вроде OpenClaw

Идея репозитория максимально простая:

```bash
git clone -> bootstrap -> start -> browser
```

Публичный репозиторий этого проекта рассчитан на сценарий:

```bash
git clone git@github.com:tolkachevspb/llamafile_-localhost.git
cd llamafile_-localhost
./bootstrap.sh bootstrap
./llm.sh start
./llm.sh open
```

## GitHub About

- Description: `Local AI stack for macOS Apple Silicon based on llamafile with browser UI, OpenAI-compatible API, model profiles, and bootstrap scripts.`
- Suggested topics: `llamafile, llm, local-ai, apple-silicon, macos, gguf, openai-compatible, qwen, self-hosted, openclaw`

## At a Glance

| Что | В проекте |
|---|---|
| Runtime | `llamafile v0.9.3` |
| Платформа | macOS Apple Silicon |
| UI | встроенный web UI на `localhost` |
| API | OpenAI-compatible `/v1` |
| Bootstrap-профиль | `Qwen2.5-1.5B-Instruct Q4_K_M` |
| Основной рабочий профиль | `Qwen2.5-7B-Instruct Q4_K_M` |
| Для чего | чат, анализ текста, PoC, локальные интеграции, agent-эксперименты |
| Для чего не рассчитан | enterprise-кластер, multi-node infra, тяжелый production orchestration |

## Who This Is For

- разработчики, которым нужен локальный OpenAI-compatible endpoint
- пользователи macOS Apple Silicon, которым хочется быстрый self-hosted LLM setup
- те, кто делает agent PoC, локальные AI-интеграции и playground-эксперименты
- те, кому важен приватный локальный контур для чата и анализа текста

## Who This Is Not For

- тех, кому нужен Kubernetes, distributed inference или enterprise-оркестрация
- production-команд, которым нужен жесткий security/safety baseline для сложных агентов
- сценариев, где обязательно нужны очень большие модели и высокая параллельность
- пользователей, которые хотят универсальный multi-platform toolkit без привязки к macOS Apple Silicon

## Что установлено

- `llamafile v0.9.3` как стабильный базовый рантайм.
- Локальный web UI, встроенный в `llamafile`.
- OpenAI-compatible API на `http://127.0.0.1:8080/v1`.
- Скрипты запуска, остановки, healthcheck и тестового промпта.
- Минимальный Python-клиент без внешних зависимостей.
- Публичная структура репозитория без закоммиченных моделей и без машинозависимых артефактов.

Проект построен на базе `llamafile`:

- GitHub: `https://github.com/Mozilla-Ocho/llamafile`
- Исходники и документация рантайма: `https://github.com/Mozilla-Ocho/llamafile`

## Почему выбрана именно эта схема

Приоритет был на простоту, стабильность и воспроизводимость. Поэтому стек собран без Docker, без отдельного UI-сервера и без дополнительных Python-зависимостей: `llamafile` уже умеет поднимать браузерный интерфейс и совместимый API.

В релизах `llamafile` уже есть `0.10.0`, но авторы отдельно предупреждают, что это переход на новую сборочную систему, где часть привычного поведения могла измениться. Для сценария "скачал / запустил / работает" базой выбран `0.9.3`.

Изначально стартовой моделью планировался `Qwen2.5-7B-Instruct Q4_K_M`, потому что это лучший баланс качества под 24 ГБ RAM. На практике для первичной сборки на текущем канале загрузки такой multipart-профиль оказался слишком тяжелым как bootstrap-выбор. Поэтому активным дефолтом проекта сделан `Qwen2.5-1.5B-Instruct Q4_K_M`, а `7B` оставлен как рекомендуемый апгрейд после первого успешного запуска.

## Что входит в публичный репозиторий

- shell-скрипты для bootstrap, запуска, остановки и проверки
- HTML-страницы с обзором проекта и шпаргалкой
- Python-клиент
- пример конфигурации
- документация по профилям модели и сценариям использования

Что специально не коммитится:

- скачанные модели
- скачанный бинарник `llamafile`
- локальный `config.env`
- логи, PID-файлы и временные артефакты

## Что умеет этот проект

- Локально запускать open-source LLM на macOS Apple Silicon.
- Давать браузерный UI для чата на `localhost`.
- Поднимать OpenAI-compatible API для скриптов, утилит и PoC.
- Быстро переключаться между легким bootstrap-профилем и основным рабочим профилем.
- Работать как локальный backend для AI-инструментов, которые умеют OpenAI-compatible endpoint.

## Прикладные сценарии

### 1. Локальный чат без облака

- Открываете браузер, заходите на `http://127.0.0.1:8080` и работаете с моделью полностью локально.

### 2. Анализ и разбор текста

- Суммаризация заметок
- Выжимка из длинных документов
- Быстрый черновой анализ статей, писем, требований и заметок

### 3. PoC для внутренних AI-инструментов

- Локальный playground для prompt engineering
- Проверка OpenAI-compatible интеграций
- Минимальный backend для внутренних прототипов

### 4. Основа для агентных экспериментов

- Тестовый локальный endpoint для Python-оркестраторов
- Подключение к tool-using PoC
- Быстрая отладка поведения локальной модели до подключения облака

### 5. Автономный fallback

- Когда не хочется зависеть от внешнего API
- Когда важна приватность локального контура
- Когда нужен запасной offline-ish сценарий для экспериментов

## Рекомендуемые модели под 24 ГБ RAM

### 1. Рекомендуемый рабочий вариант: `Qwen2.5-7B-Instruct Q4_K_M`

- Зачем: лучший баланс качества, скорости и разумного потребления памяти для чата, анализа текста и PoC.
- Файл(ы): около 7.6 ГБ суммарно.
- Практический профиль памяти: обычно комфортнее держать контекст до `8192`, не разгоняя параллелизм.
- Компромисс: скачивается дольше и тяжелее, чем bootstrap-профиль, но заметно полезнее в реальной работе.

### 2. Активный bootstrap-вариант: `Qwen2.5-1.5B-Instruct Q4_K_M`

- Зачем: надежный первый запуск, быстрый cold start, удобно для smoke test, API-проверок и легких PoC.
- Файл: около 1.8 ГБ.
- Компромисс: заметно слабее 7B на сложных инструкциях, длинном анализе и агентных сценариях.

### 3. Более мощный, но еще допустимый: `Qwen2.5-14B-Instruct Q4_K_M`

- Зачем: когда важнее качество ответов, чем скорость.
- Файл(ы): около 14.8 ГБ суммарно.
- Практический профиль памяти: использовать осторожно, со сниженным контекстом и без лишних параллельных запросов.
- Компромисс: выше риск упереться в память и просесть по скорости на 24 ГБ RAM.

## Структура проекта

```text
llamafile_-localhost/
├── bin/
├── models/
├── logs/
├── run/
├── downloads/
├── config.env.example
├── bootstrap.sh
├── start.sh
├── stop.sh
├── healthcheck.sh
├── prompt-test.sh
├── llm.sh
├── client.py
├── download-model.sh
├── switch-model.sh
├── cloud.env.example
├── LICENSE
├── .gitignore
├── README.md
├── CONFIG.md
└── SMOKE_TEST_RESULT.md
```

## Быстрый старт

```bash
git clone git@github.com:tolkachevspb/llamafile_-localhost.git
cd llamafile_-localhost
./bootstrap.sh bootstrap
./start.sh
```

Или сразу на основном профиле:

```bash
./bootstrap.sh recommended
./llm.sh start
```

После успешного старта:

- UI: `http://127.0.0.1:8080`
- API: `http://127.0.0.1:8080/v1`

Открыть UI можно так:

```bash
./llm.sh open
```

Проверить API:

```bash
./healthcheck.sh
```

Тестовый запрос:

```bash
./prompt-test.sh "Коротко объясни, что ты локальная модель."
```

Python-клиент:

```bash
python3 client.py "Сделай короткий ответ по-русски"
```

## Быстрый апгрейд на 7B

Скачать рекомендуемый профиль:

```bash
./download-model.sh recommended
```

Переключить проект на него:

```bash
./switch-model.sh recommended
./llm.sh restart
```

Короткий путь через helper:

```bash
./llm.sh download recommended
./llm.sh use-7b
./llm.sh restart
```

## Как менять модель

1. Скачайте нужный GGUF в папку `models/`.
2. Скопируйте `config.env.example` в `config.env`, если еще не сделали этого.
3. Обновите `MODEL_FILE` и при желании `MODEL_ALIAS` в `config.env`.
4. Перезапустите сервер:

```bash
./stop.sh
./start.sh
```

Если новая модель слишком тяжелая, сначала уменьшите:

- `CTX_SIZE`
- `BATCH_SIZE`
- `PARALLEL`
- при необходимости оставьте активным 1.5B-профиль

По умолчанию публичный шаблон запускает `PARALLEL=2`, чтобы сервер мог обслуживать больше одного запроса. Если нужен максимально стабильный интерактивный отклик на слабой машине, уменьшите до `1`.

## Helper-скрипт

Вместо отдельных скриптов можно использовать один хелпер:

```bash
./llm.sh start
./llm.sh status
./llm.sh health
./llm.sh test "Проверь локальный стенд"
./llm.sh download recommended
./llm.sh use-bootstrap
./llm.sh use-7b
./llm.sh logs
./llm.sh stop
```

## Основа на будущее

### Fallback на облако

`client.py` уже умеет работать с OpenAI-compatible API через переменные окружения:

- `AI_BASE_URL`
- `AI_API_KEY`
- `AI_MODEL`

Это позволяет позже переключиться на облачный endpoint без переписывания клиентского кода.

Шаблон лежит в `cloud.env.example`.

### Основа для агентных сценариев

Локальный endpoint совместим с форматом `chat/completions`, поэтому его можно подключать к:

- локальным агентным прототипам
- своим Python-оркестраторам
- тулзам, которые умеют OpenAI-compatible API

### Пример использования с OpenClaw

`OpenClaw` умеет работать с self-hosted моделями, если локальный сервер отдает OpenAI-compatible `/v1` endpoint. Это хорошо подходит для локальных PoC и легких agent-экспериментов, где вы хотите подставить локальную модель вместо облачного провайдера.

Практический смысл такого сценария:

- проверять локальные agent-flows
- тестировать собственные prompts и маршрутизацию
- использовать локальную модель как автономный backend для OpenClaw Gateway

Пример идеи конфигурации для кастомного OpenAI-compatible local provider:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "local/qwen2.5-7b-instruct-q4km"
      }
    }
  },
  "models": {
    "providers": {
      "local": {
        "type": "openai",
        "baseUrl": "http://127.0.0.1:8080/v1",
        "apiKey": "local"
      }
    }
  }
}
```

Важно: OpenClaw в официальной документации отдельно предупреждает, что для серьезных tool-using сценариев лучше использовать как можно более сильные локальные модели и большой контекст, а маленькие или агрессивно квантованные локальные модели повышают риск prompt injection и небезопасного поведения. Поэтому в рамках этого проекта сценарий `OpenClaw + 7B` стоит считать хорошим локальным PoC, но не “production-grade agent safety baseline”.

## Подготовка к публикации на GitHub

- Репозиторий не содержит модели и бинарники.
- Первый запуск для нового пользователя идет через `./bootstrap.sh`.
- Все локальные машинозависимые артефакты вынесены в `.gitignore`.
- Публичный remote для этого проекта: `git@github.com:tolkachevspb/llamafile_-localhost.git`

## Troubleshooting

### Модель не стартует

- Проверьте, что активный GGUF-файл полностью скачался.
- Откройте лог: `tail -n 100 logs/llamafile.log`
- Для тяжелой модели уменьшите `CTX_SIZE` до `4096`.

### Медленно отвечает

- Для 24 ГБ RAM это ожидаемо на более тяжелых профилях.
- Снизьте `CTX_SIZE` и `BATCH_SIZE`.
- Для быстрого интерактива и стабильного старта оставьте `Qwen2.5-1.5B-Instruct Q4_K_M`.

### Порт занят

- Поменяйте `PORT` в `config.env`.
- Повторите `./stop.sh` и `./start.sh`.

### UI открывается, но ответов нет

- Проверьте `./healthcheck.sh`
- Посмотрите `logs/llamafile.log`
- Убедитесь, что файл модели в `config.env` указан корректно
