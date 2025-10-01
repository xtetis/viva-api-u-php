# Для боя собирает контейнер

# Авторизируемся в DockerHub
docker login -u tetis -p j3qq4h7h2v

# Собираем контейнер для боя
docker build -t xtetis/viva-api-u-php:latest -f Dockerfile.work .

# Пушим в DockerHub
docker push xtetis/viva-api-u-php:latest