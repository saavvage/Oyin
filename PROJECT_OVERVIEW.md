# Oyin - Спортивное матчмейкинг-приложение

## Общая архитектура

**Frontend:** Flutter (Dart) - мобильное приложение (iOS/Android)
**Backend:** NestJS (TypeScript) - REST API + WebSocket
**Database:** PostgreSQL + TypeORM
**Realtime:** Socket.IO (чат)
**Push:** Firebase Cloud Messaging
**Auth:** JWT + OTP (телефон/email)

```
┌─────────────────┐         ┌──────────────────┐         ┌────────────┐
│  Flutter App     │ ──API── │  NestJS Backend   │ ──ORM── │ PostgreSQL │
│  (Dio + BLoC)    │         │  (REST + WS)      │         │            │
└─────────────────┘         └──────────────────┘         └────────────┘
         │                           │
    Firebase FCM              Telegram Gateway
    (push-уведомления)        (SMS верификация)
```

---

## Backend (NestJS)

### Структура проекта

```
Oyin_backend/src/
├── main.ts                          # Точка входа, CORS, Swagger
├── app.module.ts                    # Корневой модуль, импорт всех модулей
├── database/
│   └── ormconfig.ts                 # Подключение к PostgreSQL
├── domain/entities/                 # TypeORM-модели (таблицы БД)
│   ├── enums.ts                     # Все enum-ы проекта
│   ├── user.entity.ts               # Пользователь
│   ├── sport-profile.entity.ts      # Спортивный профиль
│   ├── game.entity.ts               # Игра/матч
│   ├── swipe.entity.ts              # Свайпы (like/dislike)
│   ├── dispute.entity.ts            # Диспуты
│   ├── jury-vote.entity.ts          # Голоса жюри
│   ├── chat-thread.entity.ts        # Чат-тред
│   ├── chat-message.entity.ts       # Сообщения
│   ├── chat-participant.entity.ts   # Участники чата
│   ├── transaction.entity.ts        # Транзакции кошелька
│   └── ...
├── infrastructure/                  # Внешние сервисы
│   ├── push/
│   │   ├── fcm.service.ts           # Firebase push-уведомления
│   │   └── push-reminder-scheduler.service.ts  # Периодические напоминания
│   └── services/
│       ├── elo.service.ts           # ELO рейтинг
│       ├── telegram-gateway.service.ts  # SMS через Telegram
│       └── email-verification.service.ts # Email верификация
└── presenter/                       # API слой (контроллеры + сервисы)
    ├── auth/                        # Авторизация
    ├── users/                       # Профили
    ├── matchmaking/                 # Матчмейкинг (свайпы)
    ├── games/                       # Игры и результаты
    ├── disputes/                    # Диспуты и жюри
    ├── chats/                       # Чаты (REST + WebSocket)
    ├── arena/                       # Лидерборд и вызовы
    └── wallet/                      # Кошелёк и магазин
```

### Основные сущности БД

> **Файл:** `src/domain/entities/enums.ts` — все enum-ы проекта (SportType, GameStatus, SwipeAction и т.д.)

**User** (`src/domain/entities/user.entity.ts`)
- Основные поля: phone, email, name, city, birthDate, avatarUrl
- Геолокация: latitude, longitude
- Игровые поля: karma, balance, reliabilityScore (0-100)
- Push: pushNotificationsEnabled, pushToken, pushPlatform
- Связи: sportProfiles[], gamesAsPlayer1[], gamesAsPlayer2[], swipes[]

**SportProfile** (`src/domain/entities/sport-profile.entity.ts`)
- sport (TENNIS, BOXING, MMA и др.), skillLevel (AMATEUR/SEMI_PRO/PRO)
- eloRating (default: 1000), gamesPlayed
- Связан с User (ManyToOne)

**Game** (`src/domain/entities/game.entity.ts`)
- player1, player2 (связи с User)
- sport, type (CASUAL_SWIPE / RANKED_CHALLENGE)
- status: PENDING → SCHEDULED → PLAYED / CONFLICT / DISPUTED / CANCELLED
- player1Score, player2Score, contractData (JSON: дата, место, координаты)

**Swipe** (`src/domain/entities/swipe.entity.ts`)
- swiper → target, action (LIKE/DISLIKE), sport
- isMutual — флаг взаимного лайка

**Dispute** (`src/domain/entities/dispute.entity.ts`)
- game, initiator, status (VOTING/RESOLVED)
- resolvedWinnerId, resolvedIsDraw
- juryVotes[] — массив голосов жюри
- evidence[] — доказательства (видео/фото)

**ChatThread / ChatMessage / ChatParticipant** — система чатов с тредами

**Transaction** (`src/domain/entities/transaction.entity.ts`)
- user, type (DAILY_REWARD, GAME_WIN, TRANSFER_IN и др.), amount, balanceAfter

---

### API Endpoints

#### Auth (`src/presenter/auth/auth.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| POST | `/auth/login` | Отправка OTP кода на телефон или email |
| POST | `/auth/verify` | Проверка кода, выдача JWT токена |

> **Ключевой файл:** `src/presenter/auth/auth.service.ts` (строки 27-304)
> - Логика отправки кодов через Telegram Gateway / SMTP / Mock
> - Верификация кодов, создание пользователя, генерация JWT
> - Mock-код `123456` при отключённых провайдерах

#### Users (`src/presenter/users/users.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/users/me` | Получить свой профиль с спорт-профилями |
| PUT | `/users/me` | Обновить имя, город, дату рождения |
| POST | `/users/me/avatar` | Загрузить аватар (макс 8МБ, jpg/png/webp) |
| POST | `/users/onboarding` | Создать спортивный профиль (онбординг) |
| PUT | `/users/me/sport-profiles` | Заменить все спорт-профили |
| PUT | `/users/me/location` | Обновить геолокацию |
| PUT | `/users/me/push-settings` | Настройки push-уведомлений |
| PUT | `/users/me/push-token` | Зарегистрировать FCM токен |

> **Ключевой файл:** `src/presenter/users/users.service.ts` (строки 13-309)
> - Загрузка аватара через multer на диск (uploads/avatars/)
> - Управление спорт-профилями
> - Синхронизация push-токенов

#### Matchmaking (`src/presenter/matchmaking/matchmaking.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/matchmaking/feed` | Лента потенциальных соперников (20 шт) |
| POST | `/matchmaking/swipe` | Свайп (like/dislike), создание матча при взаимном лайке |
| POST | `/matchmaking/reset-dislikes` | Сброс дислайков |

> **Ключевой файл:** `src/presenter/matchmaking/matchmaking.service.ts` (строки 16-347)
> - Фильтрация по расстоянию (формула Хаверсина), возрасту, виду спорта
> - Исключение уже просвайпанных пользователей
> - При взаимном лайке — автоматическое создание Game + ChatThread

#### Games (`src/presenter/games/games.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/games/my` | Список моих игр |
| GET | `/games/:gameId` | Детали игры |
| POST | `/games/:gameId/contract` | Предложить дату, место, напоминание |
| POST | `/games/:gameId/accept` | Принять контракт (PENDING → SCHEDULED) |
| POST | `/games/:gameId/result` | Отправить результат |

> **Ключевой файл:** `src/presenter/games/games.service.ts` (строки 24-384)
> - Оба игрока отправляют счёт. Если совпадает → финализация + обновление ELO
> - Если не совпадает → статус CONFLICT (можно создать диспут)
> - Награды монетами: победа +100, поражение -50, ничья +25

#### Disputes (`src/presenter/disputes/disputes.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| POST | `/disputes` | Создать диспут с доказательствами |
| GET | `/disputes/jury-duty` | Получить 10 диспутов для голосования |
| GET | `/disputes/my` | Мои диспуты |
| POST | `/disputes/:id/vote` | Проголосовать (PLAYER1/PLAYER2/DRAW) |

> **Ключевой файл:** `src/presenter/disputes/disputes.service.ts` (строки 27-568)
> - Разрешение после 3 голосов жюри
> - Обновление ELO с штрафом для проигравшего
> - Карма жюри: +50 за верный голос, +10 за участие

#### Wallet (`src/presenter/wallet/wallet.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/wallet/balance` | Баланс, стрик, последняя награда |
| POST | `/wallet/claim-daily` | Ежедневная награда (10-500 монет по стрику) |
| POST | `/wallet/transfer` | Перевод монет другому пользователю |
| GET | `/wallet/store` | Список товаров магазина |
| POST | `/wallet/buy` | Покупка товара |

#### Arena (`src/presenter/arena/arena.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/arena/leaderboard` | Топ-50 по ELO (±200 от рейтинга игрока) |
| POST | `/arena/challenge` | Вызов на ранкед-матч |

#### Chats — REST (`src/presenter/chats/chats.controller.ts`)

| Метод | Путь | Описание |
|-------|------|----------|
| POST | `/chats/threads` | Создать или получить DM-тред |
| GET | `/chats/threads` | Список всех тредов |
| GET | `/chats/threads/:id/messages` | Сообщения (пагинация по `before`) |
| POST | `/chats/threads/:id/messages` | Отправить сообщение |
| DELETE | `/chats/threads/:id` | Удалить тред |
| POST | `/chats/threads/:id/block` | Заблокировать |
| POST | `/chats/threads/:id/report` | Пожаловаться |

#### Chats — WebSocket (`src/presenter/chats/chats.gateway.ts`)

Namespace: `/chats`, авторизация через JWT в handshake.

| Event | Направление | Описание |
|-------|-------------|----------|
| `thread:join` | Client → Server | Подписка на тред |
| `thread:leave` | Client → Server | Отписка |
| `message:new` | Server → Client | Новое сообщение |
| `thread:activity` | Server → Thread | Активность в треде |

---

### ELO система

> **Файл:** `src/infrastructure/services/elo.service.ts` (строки 4-78)

- Формула: `E = 1 / (1 + 10^((opponent - player) / 400))`
- K-фактор: 40 (первые 5 игр), 30 (ранкед), 20 (казуал)
- При диспуте проигравший получает двойной штраф
- Дефолтный рейтинг: 1000

### Push-уведомления

> **Файл:** `src/infrastructure/push/fcm.service.ts` (строки 17-181)
> **Файл:** `src/infrastructure/push/push-reminder-scheduler.service.ts` (строки 13-167)

- Firebase Admin SDK для отправки через FCM
- Планировщик напоминаний: проверка каждые 60 сек
- Автоочистка невалидных токенов
- Настраиваемый интервал напоминаний (15-1440 мин)

---

## Frontend (Flutter)

### Структура проекта

```
lib/
├── main.dart                        # Точка входа: dotenv, SessionStorage, FCM
├── app/
│   ├── app.dart                     # OyinApp — проверка токена, навигация
│   ├── di/                          # Dependency Injection
│   ├── event_bus/events.dart        # События между экранами
│   ├── errors/app_errors.dart       # Обработка ошибок
│   └── ...
├── domain/entities/                 # Модели данных (DTO)
│   └── private/models/
│       ├── match_profile.dart       # Профиль для матчмейкинга
│       ├── user_profile.dart        # Профиль пользователя
│       ├── match_filters.dart       # Фильтры поиска
│       └── ...
├── infrastructure/services/         # Сервисный слой
│   ├── network/
│   │   ├── api_client.dart          # Dio HTTP клиент + токен-инжекция
│   │   ├── api_config.dart          # Base URL из .env
│   │   ├── session_storage.dart     # SharedPreferences (токен, настройки)
│   │   ├── auth_api.dart            # POST /auth/login, /auth/verify
│   │   ├── users_api.dart           # GET/PUT /users/me, аватар
│   │   ├── matchmaking_api.dart     # GET /matchmaking/feed, POST /swipe
│   │   ├── games_api.dart           # Игры и результаты
│   │   ├── chat_api.dart            # Треды и сообщения
│   │   ├── arena_api.dart           # Лидерборд и вызовы
│   │   ├── wallet_api.dart          # Кошелёк и магазин
│   │   └── disputes_api.dart        # Диспуты
│   ├── realtime/
│   │   └── chat_socket_service.dart # Socket.IO клиент для чата
│   ├── notifications/
│   │   └── push_notifications_service.dart  # Firebase FCM + локальные
│   └── location/
│       └── location_service.dart    # Геолокация (geolocator)
└── presenter/screens/               # UI экраны
    ├── guest/                       # Авторизация
    │   ├── auth_entry_screen.dart
    │   ├── phone_login_screen.dart  # Ввод телефона/email
    │   ├── verify_code_screen.dart  # Ввод OTP
    │   ├── profile_info_screen.dart # Заполнение профиля
    │   └── sport_selection_screen.dart  # Выбор спорта
    └── private/                     # Основное приложение
        ├── navbar/nav_shell.dart    # Нижняя навигация (4 таба)
        ├── match/                   # Матчмейкинг (свайпы)
        │   ├── match_screen.dart
        │   └── cubit/match_cubit.dart
        ├── search/arena_screen.dart # Лидерборд
        ├── chat/                    # Список чатов
        │   ├── chat_screen.dart
        │   └── cubit/chat_cubit.dart
        ├── messanger/               # Переписка
        │   ├── messanger_screen.dart
        │   └── cubit/messanger_cubit.dart
        ├── profile/                 # Профиль
        │   ├── profile_screen.dart
        │   └── cubit/profile_cubit.dart
        ├── wallet/                  # Кошелёк
        │   └── wallet_screen.dart
        └── settings/                # Настройки
            └── settings_screen.dart
```

### Навигация

```
Запуск приложения (main.dart)
    │
    ▼
OyinApp (app.dart) — проверка токена
    │
    ├── Нет токена → AuthEntryScreen (гостевой режим)
    │   ├── PhoneLoginScreen → VerifyCodeScreen → ProfileInfoScreen → SportSelectionScreen
    │   └── "Пропустить" → Guest Mode (ограниченный доступ)
    │
    └── Есть токен → NavShell (4 таба)
        ├── Tab 1: MatchScreen      — свайпы, поиск соперников
        ├── Tab 2: ArenaScreen      — лидерборд, ранкед вызовы
        ├── Tab 3: ChatScreen       — чаты + диспуты
        └── Tab 4: ProfileScreen    — профиль, настройки, кошелёк
```

### Стейт-менеджмент (BLoC/Cubit)

Каждый основной экран имеет свой Cubit:

**MatchCubit** (`lib/presenter/screens/private/match/cubit/match_cubit.dart`)
- `loadFeed()` → GET /matchmaking/feed
- `likeCurrent()` / `dislikeCurrent()` → POST /matchmaking/swipe
- `updateFilters()` → обновление фильтров (расстояние, возраст, спорт)

**ChatCubit** (`lib/presenter/screens/private/chat/cubit/chat_cubit.dart`, строки 8-106)
- `loadThreads()` → GET /chats/threads
- `loadDisputes()` → GET /disputes/my
- `selectTab()` → переключение вкладок (Action Required / Upcoming)

**MessangerCubit** (`lib/presenter/screens/private/messanger/cubit/messanger_cubit.dart`)
- `loadMessages()` → GET /chats/threads/:id/messages
- `sendMessage()` → POST /chats/threads/:id/messages
- Infinite scroll пагинация через параметр `before`

**ProfileCubit** (`lib/presenter/screens/private/profile/cubit/profile_cubit.dart`)
- Загрузка профиля, обновление аватара, управление спорт-профилями

### HTTP-клиент и авторизация

> **Файл:** `lib/infrastructure/services/network/api_client.dart` (строки 7-139)

- HTTP клиент: **Dio** с логированием запросов/ответов
- Timeout: 15 секунд
- Перед каждым запросом инжектируется JWT токен из SessionStorage (строка 26):
  ```dart
  headers['Authorization'] = 'Bearer $token';
  ```

> **Файл:** `lib/infrastructure/services/network/session_storage.dart` (строки 5-112)

- Хранение через **SharedPreferences**
- Ключи: `access_token`, `guest_mode`, фильтры матчмейкинга, настройки push, locale

### WebSocket клиент (чат в реальном времени)

> **Файл:** `lib/infrastructure/services/realtime/chat_socket_service.dart` (строки 10-163)

- Библиотека: **socket_io_client**
- Namespace: `/chats`
- Авторизация: Bearer token через `auth.token`
- Авто-переподключение (1-5 сек задержка)
- `joinThread(id)` — подписка на тред
- `messages` stream — поток новых сообщений для UI
- `threadActivity` stream — активность в тредах

### Push-уведомления (клиент)

> **Файл:** `lib/infrastructure/services/notifications/push_notifications_service.dart` (строки 18-321)

1. Инициализация Firebase Messaging
2. Запрос разрешений (alert, badge, sound)
3. Получение FCM токена → синхронизация с бэкендом (`PUT /users/me/push-token`)
4. Обработка foreground/background сообщений
5. Локальные тайм-напоминания через `flutter_local_notifications`

### Event Bus (межэкранные события)

> **Файл:** `lib/app/event_bus/events.dart` (строки 1-29)

- `AppEventMatch` — новый матч
- `AppEventMatchMessage` — сообщение в матче
- `AppEventDeleteMatch` — удаление матча
- `AppEventUpdateBalance` — обновление баланса кошелька

---

## Ключевые бизнес-процессы

### 1. Регистрация и вход

```
1. Пользователь вводит телефон или email
2. Backend отправляет OTP код (Telegram Gateway / SMTP / Mock 123456)
3. Пользователь вводит код
4. Backend проверяет код, создаёт пользователя (если новый), выдаёт JWT
5. Frontend сохраняет токен в SharedPreferences
6. Если isNewUser — онбординг (имя, спорт, уровень)
```

### 2. Матчмейкинг

```
1. GET /matchmaking/feed — backend выдаёт 20 профилей с фильтрами
2. Пользователь свайпает (like/dislike)
3. POST /matchmaking/swipe — backend сохраняет свайп
4. Если оба поставили like (isMutual) →
   - Создаётся Game (status: PENDING)
   - Создаётся ChatThread
   - Оба получают уведомление
```

### 3. Жизненный цикл игры

```
PENDING → (proposeContract) → (acceptContract) → SCHEDULED → (submitResult) →
    ├── Счёт совпал → PLAYED (ELO обновлён, монеты начислены)
    └── Счёт не совпал → CONFLICT → (createDispute) → DISPUTED →
        → 3 голоса жюри → RESOLVED (ELO + карма + reliability обновлены)
```

### 4. Система ELO рейтинга

```
Формула: E = 1 / (1 + 10^((Ropponent - Rplayer) / 400))
K-фактор:
  - 40 — первые 5 игр (быстрая калибровка)
  - 30 — ранкед-матчи
  - 20 — казуальные матчи
При диспуте: проигравший получает x2 штраф
Стартовый рейтинг: 1000
```

### 5. Ежедневные награды

```
День 1: 10 монет
День 2: 20 монет
...
День 6: 60 монет
День 7+: 500 монет (джекпот)
Стрик сбрасывается если пропущен день
```

### 6. Результаты игр и монеты

```
Победа:  +100 монет
Ничья:   +25 монет
Поражение: -50 монет
```

---

## Конфигурация (.env)

### Backend (`Oyin_backend/.env`)

```env
# Сервер
PORT=3000
NODE_ENV=development

# База данных
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=sportmatch_dev

# JWT
JWT_SECRET=<secret>
JWT_EXPIRATION=7d

# SMS верификация (Telegram Gateway)
TELEGRAM_GATEWAY_ENABLED=false
TELEGRAM_GATEWAY_TOKEN=<token>
AUTH_ALLOW_MOCK_FALLBACK=true

# Email верификация
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=

# Firebase (push)
FCM_ENABLED=false
FCM_PROJECT_ID=oyin-e775b

# CORS
CORS_ORIGINS=http://localhost:3000,...

# Загрузка файлов
UPLOAD_AVATAR_DIR=uploads/avatars
```

### Frontend (`assets/env/.env`)

```env
API_BASE_URL=http://10.0.2.2:3000/api
```

---

## Справочник файлов для изучения кода

### Backend — самые важные файлы

| Файл | Строки | Что изучать |
|------|--------|-------------|
| `src/domain/entities/enums.ts` | все | Все enum-типы проекта |
| `src/domain/entities/user.entity.ts` | 16-115 | Модель пользователя, все поля |
| `src/domain/entities/game.entity.ts` | 15-83 | Модель игры, статусы, контракт |
| `src/presenter/auth/auth.service.ts` | 27-304 | Вся логика авторизации и OTP |
| `src/presenter/matchmaking/matchmaking.service.ts` | 16-347 | Алгоритм матчмейкинга, фильтры |
| `src/presenter/games/games.service.ts` | 24-384 | Жизненный цикл игры, ELO, монеты |
| `src/presenter/disputes/disputes.service.ts` | 27-568 | Диспуты, голосование, разрешение |
| `src/presenter/chats/chats.gateway.ts` | все | WebSocket для чата |
| `src/presenter/wallet/wallet.service.ts` | 19-185 | Кошелёк, стрики, магазин |
| `src/infrastructure/services/elo.service.ts` | 4-78 | Формула ELO рейтинга |

### Frontend — самые важные файлы

| Файл | Строки | Что изучать |
|------|--------|-------------|
| `lib/app/app.dart` | 9-72 | Инициализация, проверка токена |
| `lib/infrastructure/services/network/api_client.dart` | 7-139 | HTTP клиент, инжекция токена |
| `lib/infrastructure/services/network/session_storage.dart` | 5-112 | Хранение токена и настроек |
| `lib/infrastructure/services/realtime/chat_socket_service.dart` | 10-163 | WebSocket чат-клиент |
| `lib/infrastructure/services/notifications/push_notifications_service.dart` | 18-321 | Push-уведомления |
| `lib/presenter/screens/private/match/match_screen.dart` | все | UI матчмейкинга (свайпы) |
| `lib/presenter/screens/private/match/cubit/match_cubit.dart` | все | Стейт матчмейкинга |
| `lib/presenter/screens/private/messanger/messanger_screen.dart` | все | UI чата |
| `lib/presenter/screens/guest/phone_login_screen.dart` | 13-287 | Экран входа |
| `lib/presenter/screens/private/navbar/nav_shell.dart` | 11-50 | Навигация (4 таба) |
