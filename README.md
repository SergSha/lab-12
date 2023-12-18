# lab-12
otus | k8s

### Домашнее задание
деплой в k8s

#### Цель:
инсталляция k8s на виртуальные машины и скрипты автоматического деплоя конфигурации кластера веб портала из предыдущих занятий в k8s
бэкап конфигурации кластера

#### Критерии оценки:
Статус "Принято" ставится при выполнении перечисленных требований.


### Выполнение домашнего задания

#### Создание стенда

Стенд будем разворачивать с помощью Terraform на YandexCloud, настройку серверов будем выполнять с помощью Kubernetes.

Необходимые файлы размещены в репозитории GitHub по ссылке:
```
https://github.com/SergSha/lab-12.git
```

Схема:

<img src="pics/infra.png" alt="infra.png" />

Для начала получаем OAUTH токен:
```
https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token
```

Настраиваем аутентификации в консоли:
```
export YC_TOKEN=$(yc iam create-token)
export TF_VAR_yc_token=$YC_TOKEN
```

Скачиваем проект с гитхаба:
```
git clone https://github.com/SergSha/lab-12.git && cd ./lab-12
```

В файле provider.tf нужно вставить свой 'cloud_id':
```
cloud_id  = "..."
```

При необходимости в файле main.tf вставить нужные 'ssh_public_key' и 'ssh_private_key', так как по умолчанию соответсвенно id_rsa.pub и id_rsa:
```
ssh_public_key  = "~/.ssh/id_rsa.pub"
ssh_private_key = "~/.ssh/id_rsa"
```

Стенд был взят из лабораторной работы 5 https://github.com/SergSha/lab-05. Стенд состоит из salt-мастера master-01 и salt-миньонов: балансировщик lb-01, бэкендов be-01 и be-02, сервер хранения базы данных db-01. 

Инфраструктуру будем разворачивать с помощью Terraform, а все установки и настройки необходимых приложений будем полностью реализовывать с помощью команд SaltStack.

Для того чтобы развернуть стенд, нужно выполнить следующую команду:
```
terraform init && terraform apply -auto-approve
```

По завершению команды получим данные outputs:
```
Outputs:



Список kubernetes кластеров:
```
[user@redos lab-12]$ yc managed-kubernetes cluster list
+----------------------+---------+---------------------+---------+---------+------------------------+---------------------+
|          ID          |  NAME   |     CREATED AT      | HEALTH  | STATUS  |   EXTERNAL ENDPOINT    |  INTERNAL ENDPOINT  |
+----------------------+---------+---------------------+---------+---------+------------------------+---------------------+
| catsn44eokd4kqbc0apg | k8s-lab | 2023-12-18 07:47:40 | HEALTHY | RUNNING | https://158.160.25.182 | https://10.10.10.22 |
+----------------------+---------+---------------------+---------+---------+------------------------+---------------------+

[user@redos lab-12]$ 
```

Установка с помощью встроенного пакетного менеджера:
```
# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF
sudo dnf install -y kubectl
```

Чтобы получить учетные данные для подключения к публичному IP-адресу кластера через интернет, выполним команду:
```
yc managed-kubernetes cluster \
   get-credentials k8s-lab \
   --external
```

Добавить в конфиг файл ~/.kube/config:
```
yc managed-kubernetes cluster get-credentials --id cat9hb288obvkdtaf1u6 --external --force
```






