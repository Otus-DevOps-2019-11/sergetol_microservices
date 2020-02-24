[![Build Status](https://travis-ci.com/Otus-DevOps-2019-11/sergetol_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-11/sergetol_microservices)

# sergetol_microservices

sergetol microservices repository

# HW12

- установлены docker и docker-machine

- изучены основные команды docker для работы с образами и контейнерами

- создан новый проект docker в GCP

- поднят docker host в GCE

```
# создание docker-host
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type g1-small \
  --google-zone europe-north1-a \
  docker-host
# переключение окружения на работу с docker-host
eval $(docker-machine env docker-host)
# переключение на локальное окружение
eval $(docker-machine env --unset)
# удаление docker-host
docker-machine rm docker-host
```

- подготовлено все необходимое для сборки своего образа на docker host

```
docker build -t reddit:latest .
```

- собранный образ залит на Docker Hub

```
docker tag reddit:latest sergetol/otus-reddit:1.0
docker push sergetol/otus-reddit:1.0
```
