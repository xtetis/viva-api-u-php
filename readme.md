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

# Опять запустить контейнер
docker compose -f ./docker-compose.work.yml up

# Или одной командой 
docker compose -f ./docker-compose.work.yml pull && docker compose -f ./docker-compose.work.yml up


# Если нужно запустить как демон
docker compose -f ./docker-compose.work.yml pull && docker compose -f ./docker-compose.work.yml up -d