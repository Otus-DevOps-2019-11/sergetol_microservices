[![Build Status](https://travis-ci.com/Otus-DevOps-2019-11/sergetol_microservices.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-11/sergetol_microservices)

# sergetol_microservices

sergetol microservices repository

# HW14

- изучены варианты сетей в Docker

- проект запущен в двух bridge сетях

```
# создание сетей
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24
# запуск контейнеров
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db --volume reddit_db:/data/db mongo:latest
docker run -d --network=back_net --name post sergetol/post:2.0
docker run -d --network=back_net --name comment sergetol/comment:2.0
docker run -d --network=front_net -p 9292:9292 --name ui sergetol/ui:3.0
# подключение нужных контейнеров ко второй сети
docker network connect front_net post
docker network connect front_net comment
```

- написан compose файл; освоена работа с утилитой docker-compose

- compose файл дополнительно параметризован и изменен под кейс с двумя сетями; значения параметров в .env файле

```
# валидация compose файла
docker-compose config
# создание и старт контейнеров
docker-compose up -d
```

- изучены способы задания базового имени проекта для compose:

  - через переменную окружения COMPOSE_PROJECT_NAME
  - через запуск docker-compose с флагом -p

- создан override compose файл, в котором:

  - подключен volume с кодом приложения внутрь контейнера
  - puma запущена в debug режиме с двумя worker

```
# создание и старт контейнеров
# будет подхвачен и docker-compose.override.yml
# для корректной работы папки с кодом, которые мапятся внутрь контейнеров, должны существовать на docker host
docker-compose up -d
# создание и старт контейнеров без применения docker-compose.override.yml
docker-compose -f docker-compose.yml up -d
```

# HW13

- написаны Dockerfile для модулей приложения, освоена сборка docker-образов модулей

```
# для сборки в директории src выполнить
docker build -t <your-login>/post:1.0 ./post-py
docker build -t <your-login>/comment:1.0 ./comment
docker build -t <your-login>/ui:1.0 ./ui
```

- освоен запуск контейнеров при помощи docker run, изучены различные опции запуска (*)

```
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post <your-login>/post:1.0
docker run -d --network=reddit --network-alias=comment <your-login>/comment:1.0
docker run -d --network=reddit -p 9292:9292 <your-login>/ui:1.0
```
```
docker kill $(docker ps -q)
docker run -d --network=reddit --network-alias=post_db_new --network-alias=comment_db_new mongo:latest
docker run -d --network=reddit --network-alias=post_new --env POST_DATABASE_HOST=post_db_new <your-login>/post:1.0
docker run -d --network=reddit --network-alias=comment_new --env COMMENT_DATABASE_HOST=comment_db_new <your-login>/comment:1.0
docker run -d --network=reddit -p 9292:9292 --env POST_SERVICE_HOST=post_new --env COMMENT_SERVICE_HOST=comment_new <your-login>/ui:1.0
```

- (*) получены навыки оптимизации docker-образов, использованы базовые образы на alpine для уменьшения размера конечных образов

```
# запуск линтера из директории src
hadolint post-py/Dockerfile.2
hadolint comment/Dockerfile.2
hadolint ui/Dockerfile.3
# для сборки оптимизированных образов в директории src выполнить
docker build -f ./post-py/Dockerfile.2 -t <your-login>/post:2.0 ./post-py
docker build -f ./comment/Dockerfile.2 -t <your-login>/comment:2.0 ./comment
docker build -f ./ui/Dockerfile.3 -t <your-login>/ui:3.0 ./ui
# запуск полученных образов
docker kill $(docker ps -q)
docker volume create reddit_db
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db --volume reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post <your-login>/post:2.0
docker run -d --network=reddit --network-alias=comment <your-login>/comment:2.0
docker run -d --network=reddit -p 9292:9292 <your-login>/ui:3.0
```

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

- (*) подготовлены для тестирования собранного docker образа:

  - terraform инфраструктура и скрипты провижининга (enable_provision = true); количество VM указывается в переменной app_vm_count
```
# выполнить в директории docker-monolith/infra/terraform/test
terraform init
terraform apply
# для проверки зайти на http://app_external_ip:9292
```

  - ansible провижининг на terraform инфраструктуре (enable_provision = false); dynamic inventory сделан через плагин gcp_compute
```
# на предварительно поднятой terraform инфраструктуре выполнить в директории docker-monolith/infra/ansible
ansible-playbook playbooks/site.yml
# или, если в terraform используется предварительно собранный packer-образ docker-base, достаточно выполнить
ansible-playbook playbooks/deploy.yml
# для проверки зайти на http://app_external_ip:9292
```

  - packer сборка образа docker-base VM с установленным docker; провижининг выполняется с помощью ansible
```
# выполнить в директории docker-monolith/infra
packer build -var-file=packer/variables.json packer/docker.json
```

  - vagrant инфраструктура на virtualbox; провижининг выполняется с помощью ansible
```
# выполнить в директории docker-monolith/infra/ansible
vagrant up
# для проверки зайти на http://10.10.10.20:9292
```
