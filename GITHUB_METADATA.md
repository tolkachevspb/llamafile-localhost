# GitHub Metadata

## Repository Name

`llamafile-localhost`

## Short Description

`Local AI stack for macOS Apple Silicon based on llamafile with browser UI, OpenAI-compatible API, model profiles, and bootstrap scripts.`

## About

Локальный AI-стек для macOS Apple Silicon, построенный на базе `llamafile`.
Проект дает:

- browser UI на `localhost`
- OpenAI-compatible API
- bootstrap и helper-скрипты
- переключение между легким и рабочим профилями модели
- базу для локальных agent PoC и интеграций вроде OpenClaw

## Suggested Topics

- `llamafile`
- `llm`
- `local-ai`
- `macos`
- `apple-silicon`
- `gguf`
- `openai-compatible`
- `qwen`
- `self-hosted`
- `openclaw`

## Suggested Website

Если нужен URL для поля Website, можно использовать ссылку на обзорную страницу в репозитории или оставить поле пустым.

## Suggested Pin / Highlights

- `README.md` как основной entry point
- `PROJECT_OVERVIEW.html` как визуальное описание проекта
- `CHEATSHEET.html` как быстрый операционный reference

## Suggested Release Notes Template

### Что внутри

- локальный LLM-стек на базе `llamafile`
- browser UI и OpenAI-compatible API
- профили `1.5B` и `7B`
- helper-скрипты для bootstrap, запуска, проверки и переключения моделей
- HTML-страницы с обзором и шпаргалкой
- пример интеграции с OpenClaw

### Быстрый старт

```bash
git clone git@github.com:tolkachevspb/llamafile-localhost.git
cd llamafile-localhost
./bootstrap.sh bootstrap
./llm.sh start
./llm.sh open
```

### Для кого

- разработчики локальных AI PoC
- пользователи macOS Apple Silicon
- те, кому нужен локальный OpenAI-compatible endpoint
- те, кто хочет простой self-hosted стек без Docker-оркестрации
