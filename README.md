# Netdata (docker-compose)

Этот репозиторий содержит конфигурацию `docker-compose` для запуска Netdata — инструмента мониторинга и диагностики систем в реальном времени.

**Для чего этот файл**
- **Описание:** Этот `README.md` объясняет, зачем нужен репозиторий и как быстро запустить Netdata локально.
- **Цель:** дать простые пошаговые инструкции для Windows (PowerShell) и Linux систем, с двумя вариантами конфигурации.

**Требования**
- **Docker:** Установлен и запущен Docker Desktop (Windows) или Docker Engine (Linux).
- **docker-compose:** В большинстве современных установок Docker уже доступен.
- **Права:** Пользователь должен иметь права запускать Docker-контейнеры.

---

## Вариант 1: С встроенным nginx-proxy (рекомендуется для локальной разработки)

Этот вариант использует встроенный nginx с базовой HTTP-аутентификацией. Учётные данные берутся из файла `.env`.

### Требования для Варианта 1
- Файл `docker-compose.yml` (основной)
- Папка `nginx-proxy/` с конфигурацией прокси
- Файл `.env` с переменными окружения

### Быстрый старт Варианта 1

#### Windows (PowerShell)
1. Откройте PowerShell в папке проекта:

```powershell
cd d:\projectspython\netdata
```

2. Создайте Docker-сеть `monitoring` (если ещё не создана):

```powershell
docker network create monitoring
```

3. Создайте файл `.env` из шаблона и установите учётные данные:

```powershell
Copy-Item .env.example .env
notepad .env
```

Пример содержимого `.env`:

```
NETDATA_USER=admin
NETDATA_PASSWORD=your_secure_password
```

4. Постройте и запустите сервисы в фоне:

```powershell
docker-compose up -d --build
```

5. Откройте веб-интерфейс Netdata в браузере:

```
http://localhost:19999
```

Браузер запросит логин и пароль (из `.env`).

6. Для остановки:

```powershell
docker-compose down
```

---

#### Linux (Bash)
1. Перейдите в папку проекта:

```bash
cd /path/to/netdata
```

2. Создайте Docker-сеть `monitoring` (если ещё не создана):

```bash
docker network create monitoring
```

3. Создайте файл `.env` из шаблона и установите учётные данные:

```bash
cp .env.example .env
nano .env  # или используйте любой редактор (vim, gedit и т.д.)
```

Пример содержимого `.env`:

```
NETDATA_USER=admin
NETDATA_PASSWORD=your_secure_password
```

4. Постройте и запустите сервисы в фоне:

```bash
docker-compose up -d --build
```

5. Откройте веб-интерфейс Netdata в браузере:

```
http://localhost:19999
```

Браузер запросит логин и пароль (из `.env`).

6. Для остановки:

```bash
docker-compose down
```

---

## Вариант 2: Без встроенного прокси (для Nginx Proxy Manager или другого reverse proxy)

Этот вариант предназначен для использования с **Nginx Proxy Manager (NPM)**, Traefik, Apache или другим reverse proxy. Netdata доступен напрямую на порту 19999 внутри Docker-сети.

### Требования для Варианта 2
- Файл `docker-compose.npm-only.yml` (используется вместо основного)
- Установленный и работающий Nginx Proxy Manager (или другой reverse proxy)
- Папка `nginx-proxy/` **НЕ используется** (можно удалить)
- Файл `NPM_AUTH_SETUP.md` содержит полную инструкцию по авторизации в NPM

### Быстрый старт Варианта 2

#### Windows (PowerShell)
1. Откройте PowerShell в папке проекта:

```powershell
cd d:\projectspython\netdata
```

2. Создайте Docker-сеть `monitoring` (если ещё не создана):

```powershell
docker network create monitoring
```

3. Запустите сервисы используя конфиг `docker-compose.npm-only.yml`:

```powershell
docker-compose -f docker-compose.npm-only.yml up -d
```

4. Проверьте, что контейнер запущен:

```powershell
docker ps --filter "name=netdata"
```

5. **Настройте авторизацию в Nginx Proxy Manager:**
   
   Следуйте подробной инструкции в файле `NPM_AUTH_SETUP.md`:
   - Создайте Access List в NPM (Меню → Access List → Add Access List)
   - Добавьте Basic Auth с логином и паролем
   - Привяжите Access List к хосту Netdata (Proxy Hosts → Edit → Access)
   - Сохраните и проверьте — теперь будет запрос авторизации

6. Откройте веб-интерфейс Netdata через ваш домен:

```
https://netdata.example.com
```

Браузер запросит логин и пароль (установленные в Access List NPM).

7. Для остановки:

```powershell
docker-compose -f docker-compose.npm-only.yml down
```

---

#### Linux (Bash)
1. Перейдите в папку проекта:

```bash
cd /path/to/netdata
```

2. Создайте Docker-сеть `monitoring` (если ещё не создана):

```bash
docker network create monitoring
```

3. Запустите сервисы используя конфиг `docker-compose.npm-only.yml`:

```bash
docker-compose -f docker-compose.npm-only.yml up -d
```

4. Проверьте, что контейнер запущен:

```bash
docker ps --filter "name=netdata"
```

5. **Настройте авторизацию в Nginx Proxy Manager:**
   
   Следуйте подробной инструкции в файле `NPM_AUTH_SETUP.md`:
   - Создайте Access List в NPM (Меню → Access List → Add Access List)
   - Добавьте Basic Auth с логином и паролем
   - Привяжите Access List к хосту Netdata (Proxy Hosts → Edit → Access)
   - Сохраните и проверьте — теперь будет запрос авторизации

6. Откройте веб-интерфейс Netdata через ваш домен:

```
https://netdata.example.com
```

Браузер запросит логин и пароль (установленные в Access List NPM).

7. Для остановки:

```bash
docker-compose -f docker-compose.npm-only.yml down
```

---

## Полезные команды

### Просмотр логов
```bash
# Windows PowerShell и Linux (одинаково)
docker-compose logs -f                    # Все логи
docker-compose logs -f netdata            # Логи только netdata
docker-compose logs -f netdata-proxy      # Логи прокси (Вариант 1)
```

### Список запущенных контейнеров
```bash
# Windows PowerShell и Linux (одинаково)
docker ps
docker ps --filter "name=netdata"
```

### Перезапуск сервиса
```bash
# Windows PowerShell и Linux (одинаково)
docker-compose restart
docker-compose restart netdata
```

### Пересборка образов
```bash
# Windows PowerShell и Linux (одинаково)
docker-compose up -d --build
docker-compose -f docker-compose.npm-only.yml up -d --build
```

### Удаление контейнеров и томов
```bash
# Windows PowerShell и Linux (одинаково)
docker-compose down -v
docker-compose -f docker-compose.npm-only.yml down -v
```

---

## Структура файлов проекта

```
netdata/
├── docker-compose.yml              # Конфиг с встроенным nginx-proxy (Вариант 1)
├── docker-compose.npm-only.yml     # Конфиг без прокси (Вариант 2 - для NPM)
├── .env.example                    # Шаблон переменных окружения
├── .env                            # Файл переменных (создаётся локально, не коммитится)
├── nginx-proxy/                    # Папка с конфигурацией встроенного прокси
│   ├── Dockerfile                  # Образ nginx с htpasswd
│   ├── start.sh                    # Скрипт инициализации прокси
│   └── default.conf                # Конфиг nginx (базовая аутентификация)
└── README.md                       # Этот файл
```

---

## Часто задаваемые вопросы (FAQ)

### Вопрос: Какой вариант выбрать?

**Вариант 1 (с встроенным nginx-proxy):**
- Используйте для локальной разработки
- Если у вас нет Nginx Proxy Manager
- Если нужна быстрая установка с аутентификацией

**Вариант 2 (без прокси):**
- Используйте если уже установлен Nginx Proxy Manager
- Используйте если уже установлен другой reverse proxy (Traefik, Apache и т.д.)
- Больше контроля над аутентификацией и настройками

### Вопрос: Как изменить логин и пароль?

**Windows (PowerShell):**
```powershell
notepad .env
docker-compose down
docker-compose up -d --build
```

**Linux (Bash):**
```bash
nano .env
docker-compose down
docker-compose up -d --build
```

### Вопрос: Как подключить Netdata к NPM, если я использую Вариант 1?

1. Удалите папку `nginx-proxy/` (или просто не используйте)
2. Переключитесь на `docker-compose.npm-only.yml`:
   ```bash
   docker-compose down
   docker-compose -f docker-compose.npm-only.yml up -d
   ```
3. Следуйте инструкции для Варианта 2 выше

### Вопрос: Ошибка "external network monitoring not found"

Сначала создайте сеть:

```bash
docker network create monitoring
```

Если вы не хотите использовать внешнюю сеть, отредактируйте `docker-compose.yml` и удалите `external: true` в секции `networks`.

### Вопрос: Как проверить логи ошибок?

```bash
# Windows PowerShell и Linux
docker-compose logs -f netdata
docker-compose logs -f netdata-proxy
```

---

## Отладка и советы

- **Если Netdata не доступен:** проверьте, что контейнеры запущены (`docker ps`), и посмотрите логи (`docker-compose logs -f`).
- **Если доступ требует пароль но пароль неправильный:** проверьте файл `.env`, убедитесь что он скопирован из `.env.example` и содержит правильные значения.
- **Если порт 19999 занят:** измените портом в `docker-compose.yml` (строка `ports:`).
- **Если сеть `monitoring` не работает:** используйте `docker network ls` для проверки, удалите и пересоздайте её:
  ```bash
  docker network rm monitoring
  docker network create monitoring
  ```

---

## Дополнительная информация

- [Официальный сайт Netdata](https://www.netdata.cloud/)
- [Документация Netdata](https://learn.netdata.cloud/)
- [Nginx Proxy Manager](https://nginxproxymanager.com/)
- [Docker документация](https://docs.docker.com/)

---

Файл создан и поддерживается автоматически. Если нужны уточнения или изменения — откройте issue или напишите в комментариях.


