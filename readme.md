### Универсальный API (специально для VIVA)

#### Общая информация
API сервис предстваляет собой Docker контейнер, который работает в связке с базой PostgreSQL (где хранятся настройки API сервиса).

#### Настройки сервиса
1. **API_DB_HOST** — хост базы данных (обязательный параметр)
2. **API_DB_PORT** — Порт базы данных (обязательный параметр)
3. **API_DB_DATABASE** — Имя базы данных (обязательный параметр)
4. **API_DB_USERNAME** — Логин базы данных (обязательный параметр)
5. **API_DB_PASSWORD** — Пароль базы данных (обязательный параметр)
6. **APP_DEBUG** — Включить ли режим отладки (необязательный параметр)
7. **APP_SCHEME** — Схема доступа к приложению (обязательный параметр)
8. **APP_ENABLE_HTTP_BASE_AUTH** — Включить ли базовую авторизацию для доступа к тестовым страницам (обязательный параметр)
9. **HTTP_BASE_LOGIN** — Логин базового пользователя (является обязательным параметром если включена базовая авторизация)
10. **HTTP_BASE_PASSWORD** — MD5 хэш пароля базового пользователя (является обязательным параметром если включена базовая авторизация) 

Настройки сервиса хранятся в 
 - docker-compose.dev.eis.yml
 - docker-compose.dev.local.yml
 - docker-compose.work.yml

При этом, на DEV контуре, правильно использовать docker-compose.dev.eis.yml, предварительно создав на файл символическую ссылку 
```sh  
ln -s ./docker-compose.dev.eis.yml docker-compose.yml 
```
Таким образом, при перезапуске автоматически будет использоваться корректный yml файл

На PROD контуре , правильно использовать docker-compose.work.yml, предварительно создав на файл символическую ссылку 
```sh  
ln -s ./docker-compose.work.yml docker-compose.yml 
```

#### Скрипты для работы с контейнером
1. **sh__build_push_container.sh** — сборка контейнера со скриптыми внутри (полностью изолированный)
2. **sh__pull_container.sh** — 
3. **sh__run_container__daemon.sh** — 
4. **sh__run_container__process.sh** — 
5. **sh__stop_container__daemon.sh** — 
Запрос состоит из объекта `request` с необходимыми параметрами и поля `from`, определяющего источник данных:
- `from`:
  - `1` — получение данных напрямую от партнера (результат сохраняется в базу данных).
  - `2` — получение данных из базы данных, при их отсутствии — запрос к партнеру.
  - `3` — получение данных из базы данных, при их отсутствии возвращается пустой ответ.

#### Примеры запросов
- **Для `service_bs_company_v2`:**
  ```json
  {
      "request": {
          "company": {
              "name": "АО ОКБ",
              "inn": "7710561081",
              "ogrn": "1047796788819"
          },
          "consent": {
              "received_at": "2020-10-15",
              "responsibility_flag": true,
              "was_received": true
          }
      },
      "from": 1
  }
  ```
- **Для `service_entrepreneur_v1`:**
  ```json
  {
      "request": {
          "inn": "273453701673",
          "person": {
              "name": "ФЕДОР",
              "surname": "ГЛЕБЧЕНКО",
              "patronymic": "БОРИСОВИЧ",
              "birthday": "1971-08-12",
              "passport": {
                  "serial": "4511",
                  "number": "258974",
                  "issued_at": "2014-09-14"
              }
          },
          "consent": {
              "received_at": "1900-01-01",
              "was_received": true,
              "responsibility_flag": true
          }
      },
      "from": 1
  }
  ```

#### Варианты отправки запросов
1. Отправка на корневой URL сервиса (**https://okb-dev.vivadengi.ru/**), где `method` и `request` передаются как POST-параметры.
2. Отправка на адрес **/api/{method}**, где `{method}` — имя метода, а `request` — POST-параметр.
3. Отправка на адрес **/api/{method}**, где `{method}` — имя метода, а `request` — тело запроса.

#### Директории
- Примеры JSON-запросов: `/var/www/okb-dev.vivadengi.ru/assets/data/json_example`
- Валидаторы JSON-запросов: `/var/www/okb-dev.vivadengi.ru/assets/data/json_schema`
- Описания запросов: `/var/www/okb-dev.vivadengi.ru/assets/data/html_description`

#### Примеры cURL-запросов
- **Для `service_bs_company_v2`:**
  ```bash
  curl --location -g '{{HOST}}/api/service_bs_company_v2' \
  --data '{
      "request": {
          "company": {
              "name": "АО ОКБ",
              "inn": "7710561081",
              "ogrn": "1047796788819"
          },
          "consent": {
              "received_at": "2020-10-15",
              "responsibility_flag": true,
              "was_received": true
          }
      },
      "from": 1
  }'
  ```
- **Для `service_entrepreneur_v1`:**
  ```bash
  curl --location -g '{{HOST}}/api/service_entrepreneur_v1' \
  --data '{
      "request": {
          "inn": "273453701673",
          "person": {
              "name": "ФЕДОР",
              "surname": "ГЛЕБЧЕНКО",
              "patronymic": "БОРИСОВИЧ",
              "birthday": "1971-08-12",
              "passport": {
                  "serial": "4511",
                  "number": "258974",
                  "issued_at": "2014-09-14"
              }
          },
          "consent": {
              "received_at": "1900-01-01",
              "was_received": true,
              "responsibility_flag": true
          }
      },
      "from": 1
  }'
  ```

#### Примеры ответов
- **Для `service_bs_company_v2`:**
  ```json
  {
      "result": 1,
      "result_str": "OK",
      "run_data": {
          "web_request": false,
          "partner_response_data": {
              "status": true,
              "data": {
                  "params": {
                      "score": 5,
                      "probability": 0.45,
                      "variables": {
                          "basic_info": 110,
                          "courts": -44,
                          "finance": 27,
                          "leaders": -4,
                          "lpr_ch": 42,
                          "credit_activity": 72,
                          "credit_delays": -1,
                          "kinds_of_activity": null
                      }
                  },
                  "is_hit": true
              },
              "message": "OK",
              "response_ids": [],
              "request_id": "1220e6e0-adb7-4937-8644-c3f3270edfef"
          },
          "service_request_key": 75,
          "service_message": "Данные получены от партнера"
      }
  }
  ```
- **Для `service_entrepreneur_v1`:**
  ```json
  {
      "result": 1,
      "result_str": "OK",
      "run_data": {
          "web_request": false,
          "partner_response_data": {
              "data": {
                  "params": {
                      "variables": {
                          "structure": 1.2343,
                          "credit_delays": 1.2343,
                          "credit_activity": 1.2343,
                          "bank_requests": 1.2343,
                          "execution_proceedings": 1.2343
                      },
                      "probability": 1.2343,
                      "score": 1.2343
                  },
                  "is_hit": true
              },
              "message": "OK"
          },
          "service_request_key": 77,
          "service_message": "Данные получены от партнера"
      }
  }
  ```

#### Схемы валидации JSON
- **Для `service_bs_company_v2`:**
  ```json
  {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
          "request": {
              "type": "object",
              "properties": {
                  "company": {
                      "type": "object",
                      "properties": {
                          "name": {"type": "string"},
                          "inn": {"type": "string"},
                          "ogrn": {"type": "string"}
                      },
                      "required": ["name", "inn", "ogrn"]
                  },
                  "consent": {
                      "type": "object",
                      "properties": {
                          "received_at": {"type": "string"},
                          "responsibility_flag": {"type": "boolean"},
                          "was_received": {"type": "boolean"}
                      },
                      "required": ["received_at", "responsibility_flag", "was_received"]
                  }
              },
              "required": ["company", "consent"]
          },
          "from": {"type": "integer"}
      },
      "required": ["request", "from"]
  }
  ```
- **Для `service_entrepreneur_v1`:**
  ```json
  {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "type": "object",
      "properties": {
          "request": {
              "type": "object",
              "properties": {
                  "inn": {"type": "string"},
                  "person": {
                      "type": "object",
                      "properties": {
                          "name": {"type": "string"},
                          "surname": {"type": "string"},
                          "patronymic": {"type": "string"},
                          "birthday": {"type": "string"},
                          "passport": {
                              "type": "object",
                              "properties": {
                                  "serial": {"type": "string"},
                                  "number": {"type": "string"},
                                  "issued_at": {"type": "string"}
                              },
                              "required": ["serial", "number", "issued_at"]
                          }
                      },
                      "required": ["name", "surname", "patronymic", "birthday", "passport"]
                  },
                  "consent": {
                      "type": "object",
                      "properties": {
                          "received_at": {"type": "string"},
                          "was_received": {"type": "boolean"},
                          "responsibility_flag": {"type": "boolean"}
                      },
                      "required": ["received_at", "was_received", "responsibility_flag"]
                  }
              },
              "required": ["inn", "person", "consent"]
          },
          "from": {"type": "integer"}
      },
      "required": ["request", "from"]
  }
  ```
  
  
  
 Запуск контейнера с постройкой
docker-compose up --build


Запуск контейнера без перестройки контейнера
docker-compose up


-- Постройка Docker контейнера
docker build -t viva-api-u-php:latest .

Просмотреть список построенных контейнеров
docker images
REPOSITORY         TAG          IMAGE ID       CREATED         SIZE
viva-api-u-php     latest       b3cf671c9aa7   6 minutes ago   542MB
...


-- Не помню
docker tag viva-api-u-php:latest xtetis/viva-api-u-php:latest


-- Авторизиция в dockerHub
docker login

-- Пуш в dockerHub
docker pull xtetis/viva-api-u-php:latest
docker build -t xtetis/viva-api-u-php:latest -f Dockerfile.work .


-- Урл залитого контейнера 
https://hub.docker.com/repository/docker/xtetis/viva-api-u-php/general

Для прода
docker-compose -f /mydata/work/VIVA/web/api/docker-compose.work.yml up --build

docker-compose -f ./docker-compose.dev.yml up --build

=====================================================================


Это универсальный API для вивы


docker buildx install

# Build the image
docker build -t xtetis/viva-api-u-php:latest -f Dockerfile.work .

# (Optional) Build with buildx
docker buildx build -t xtetis/viva-api-u-php:latest -f Dockerfile.work .

# Log in to Docker Hub
docker login

# Push the image
docker push xtetis/viva-api-u-php:latest



# На бою обновить боевой контейнер
docker compose -f ./docker-compose.work.yml pull

# В директории с docker-compose.yml обновить контейнер
docker compose pull
docker compose up -d

# Опять запустить контейнер
docker compose -f ./docker-compose.work.yml up

# Или одной командой 
docker compose -f ./docker-compose.work.yml pull && docker compose -f ./docker-compose.work.yml up


# Если нужно запустить как демон
docker compose -f ./docker-compose.work.yml pull && docker compose -f ./docker-compose.work.yml up -d