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
