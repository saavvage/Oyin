# Oyin Frontend (Flutter)

Мобильное приложение для поиска спарринг-партнёров, проведения челленджей и отслеживания рейтинга.

## Технологии

- **Flutter** 3.10+ / Dart
- **State management**: BLoC / Cubit (`flutter_bloc`)
- **HTTP**: Dio
- **Realtime**: Socket.IO (`socket_io_client`)
- **Push**: Firebase Messaging (`firebase_messaging`)
- **Локализация**: Кастомная реализация (EN / RU / KZ)
- **Геолокация**: `geolocator`

## Структура проекта

```
lib/
├── app/                    # Точка входа, тема, локализация
│   ├── app.dart            # OyinApp — корневой виджет
│   └── localization/       # Переводы (en, ru, kk)
├── domain/                 # Сущности и модели
│   └── entities/
├── infrastructure/         # Сервисы, API, сеть
│   └── services/
│       ├── network/        # API клиенты (auth, users, games, wallet, etc.)
│       ├── realtime/       # WebSocket (чат)
│       ├── notifications/  # Push-уведомления
│       └── location/       # GPS-геолокация
└── presenter/              # UI + BLoC
    ├── screens/
    │   ├── guest/          # Авторизация, онбординг
    │   └── private/        # Основные экраны (профиль, чаты, матчи, кошелёк)
    └── extensions/         # Тема, утилиты
```

## Настройка

### 1. Установить зависимости
```bash
flutter pub get
```

### 2. Настроить API URL
Файл: `assets/env/.env`
```env
# iOS simulator
API_BASE_URL=http://localhost:3000
# Android emulator
# API_BASE_URL=http://10.0.2.2:3000
```

### 3. Запустить
```bash
flutter run
```

## Авторизация

Поддерживается два способа входа:
- **Телефон** — SMS-код (mock: `123456` в dev-режиме)
- **Email** — код на почту (mock: `123456` если SMTP не настроен)

После верификации: JWT-токен сохраняется в `SharedPreferences`. При следующем запуске авторизация не требуется.

## Локализация

3 языка: English, Русский, Қазақша. Выбор языка сохраняется между сессиями. Файл: `lib/app/localization/app_localizations.dart`.

## Основные экраны

| Экран | Описание |
|-------|----------|
| Match (Discovery) | Свайп-поиск спарринг-партнёров |
| Search (Arena) | Рейтинг-таблица и вызовы на челлендж |
| Chats | Мессенджер с поддержкой вложений |
| Profile | Статистика, настройки, кошелёк |
| Wallet | Баланс монет, магазин, переводы |

## Связь с бэкендом

Бэкенд: `../Oyin_backend` (NestJS + PostgreSQL). Запускается через Docker:
```bash
cd ../Oyin_backend && docker compose up -d
```
