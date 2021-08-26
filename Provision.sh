#! /bin/bash
# change hostname
hostnamectl set-hostname syn-app01
# install python3
apt update
apt install software-properties-common -y
add-apt-repository ppa:deadsnakes/ppa -y 
apt install python3.8 -y
# install docker and docker-compose
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update
apt-get install docker-ce -y
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
chmod 755 '/usr/local/bin/docker-compose'
# configure docker-compose.yml
sudo mkdir -p /tmp/syntax
cat > /tmp/syntax/docker-compose.yml <<EOL
version: '3.7'

services:
  web:
    image: django:latest
    command: gunicorn hello_django.wsgi:application --bind 0.0.0.0:8000
    volumes:
      - static_volume:/home/app/web/staticfiles
      - media_volume:/home/app/web/mediafiles
    ports:
      - "8000:8000"
    environment:
      SQL_ENGINE: django.db.backends.postgresql
      SQL_DATABASE: "${SQL_DATABASE}"
      SQL_USER: "${SQL_USER}"
      SQL_PASSWORD: "{SQL_PASSWORD}"
      SQL_PORT: "{SQL_PORT}"
volumes:
  static_volume:
  media_volume:
EOL
sed -i 's/SQL_DATABASE:/SQL_DATABASE: "${SQL_DATABASE}"/g' /tmp/syntax/docker-compose.yml
sed -i 's/SQL_USER/SQL_USER: "${SQL_USER}"/g' /tmp/syntax/docker-compose.yml
sed -i 's/SQL_PASSWORD/SQL_PASSWORD: "{SQL_PASSWORD}"/g' /tmp/syntax/docker-compose.yml
sed -i 's/SQL_PORT/SQL_PORT: "{SQL_PORT}"/g' /tmp/syntax/docker-compose.yml
docker-compose -f /tmp/syntax/docker-compose.yml up -d


