# lab-12
otus | kubernetes

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

```
[user@redos lab-12]$ yc managed-kubernetes cluster \
   get-credentials k8s-lab \
   --external

Context 'yc-k8s-lab' was added as default to kubeconfig '/home/user/.kube/config'.
Check connection to cluster using 'kubectl cluster-info --kubeconfig /home/user/.kube/config'.

Note, that authentication depends on 'yc' and its config profile 'tfadmin'.
To access clusters using the Kubernetes API, please use Kubernetes Service Account.
[user@redos lab-12]$
```

Добавить в конфиг файл ~/.kube/config:
```
yc managed-kubernetes cluster get-credentials --id cat9hb288obvkdtaf1u6 --external --force
```

```
[user@redos lab-12]$ kubectl api-versions
admissionregistration.k8s.io/v1
apiextensions.k8s.io/v1
apiregistration.k8s.io/v1
apps/v1
authentication.k8s.io/v1
authorization.k8s.io/v1
autoscaling/v1
autoscaling/v2
autoscaling/v2beta2
batch/v1
certificates.k8s.io/v1
coordination.k8s.io/v1
discovery.k8s.io/v1
events.k8s.io/v1
flowcontrol.apiserver.k8s.io/v1beta1
flowcontrol.apiserver.k8s.io/v1beta2
metrics.k8s.io/v1beta1
networking.k8s.io/v1
node.k8s.io/v1
policy/v1
rbac.authorization.k8s.io/v1
scheduling.k8s.io/v1
snapshot.storage.k8s.io/v1
snapshot.storage.k8s.io/v1beta1
storage.k8s.io/v1
storage.k8s.io/v1beta1
v1
[user@redos lab-12]$
```









yc managed-kubernetes cluster get-credentials k8s-lab --external

yc managed-kubernetes cluster get-credentials ${self.name} --external --force --kubeconfig ../charts/kube-config

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace --kubeconfig='./kube-config'
  
  "https://kubernetes.github.io/ingress-nginx"

helm install percona ./Charts/percona/ -f ./Charts/values.yaml \
  --kubeconfig='./kube-config'

helm install wordpress ./Charts/wordpress/ -f ./Charts/values.yaml \
  --kubeconfig='./kube-config'










[user@rocky9 lab-12]$ yc managed-kubernetes cluster get-credentials k8s-lab --external

Context 'yc-k8s-lab' was added as default to kubeconfig '/home/user/.kube/config'.
Check connection to cluster using 'kubectl cluster-info --kubeconfig /home/user/.kube/config'.

Note, that authentication depends on 'yc' and its config profile 'default'.
To access clusters using the Kubernetes API, please use Kubernetes Service Account.
There is a new yc version '0.115.0' available. Current version: '0.113.0'.
See release notes at https://cloud.yandex.ru/docs/cli/release-notes
You can install it by running the following command in your shell:
	$ yc components update

[user@rocky9 lab-12]$ kubectl get nodes
NAME                        STATUS   ROLES    AGE   VERSION
cl1aihlvbhor3hnnack0-anew   Ready    <none>   23m   v1.25.4
[user@rocky9 lab-12]$ 



[user@rocky9 lab-12]$ helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
Release "ingress-nginx" does not exist. Installing it now.
NAME: ingress-nginx
LAST DEPLOYED: Mon Jan  8 16:07:43 2024
NAMESPACE: ingress-nginx
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the load balancer IP to be available.
You can watch the status by running 'kubectl get service --namespace ingress-nginx ingress-nginx-controller --output wide --watch'

An example Ingress that makes use of the controller:
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: example
    namespace: foo
  spec:
    ingressClassName: nginx
    rules:
      - host: www.example.com
        http:
          paths:
            - pathType: Prefix
              backend:
                service:
                  name: exampleService
                  port:
                    number: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
      - hosts:
        - www.example.com
        secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
[user@rocky9 lab-12]$ 





[user@rocky9 lab-12]$ cat ~/.kube/config 
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJME1ERXdPREV5TXpFME1Wb1hEVE0wTURFd05URXlNekUwTVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTFgzCkY4RExtanFYMWh6K1dONk1TTlAyVXBPUDM1Sy9zMmM4dWlodjV2enQ2cytBNURnQ3ZEK3lqS1grYXdXczJDL1YKVmtVLytiSHdBNEtnU0RMdzhybWZ0WGRURm55d1VycEhFbnRwWFl4dUtyVVp0WVNXYk5GZnRXRy9taVRMN2IwTApkVGxxYnZoTDFCNEdKcTczbGVvUzhIc3VMOTFkL3RkN21PWHhWUWJXNW1Na3ZVbTBEUDM5UkZUSVhhVTRTb0JSClZ3N2dVRTZrd1lPOERxb2VFVkR2VUYwN3NkaUdVQzI3ZkZUTjZUenRMRGwzWlRmYnR5WGZhQjVQT1RHYnBvU0gKdTczbDRZNDA3UU9PM092dlVVbzd4VmszVTRveHRqaHlQM1FiUmdoSERsTVZWZXpSSUVyZHRFQTNOVHh4cTRuLwo0VmxDeG1BYXVQL3JFWTk5dnljQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZFZU1zQSsrck1FZ3dsTm92THdFY1RSZk5IdWhNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFCSVRWVkZnK0JEMDE3WXMvdk96YVhXRnA4TmZLS0k2NG9MbzhDUkdKTEc5eStSRUdxYQpkNlNOZnE2aDAybFZyY1RKR2J5WjlhL3JXelR0Wjg0ZkFLV2dBNHN1cm13eXZ6d2JuaEJjWG9wR0loSVY3TFFOCnphZzkzUjBCbUNrei8vZXpmU0s2TFkvQklFZmltMUlsa0RReXlBZk1IcERsKzRYWGFiRkp6emlqV3I3MGZ6d3gKWWlEQ0NubTVaUjZiaTkwNGw1R3VmeXRTcXhqNExXRU50dTg1dlFNZ1E2Ym96c2RkbU5hdFdka0hQay9waXViMQpCN0ROSEZ6VzF3NzdZcVdqMkhnRGlBazBHdjFyam5JMEVSUENySG9hVTV5a2ZMdjBzZWozbm92ZWtXNjFwR3NDClhNemxDWGVKeGFIQTExclVOakpQTFk4bXRvcDhTMVVTVlpDbQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://158.160.6.183
  name: yc-managed-k8s-catac9t0isbujgbo11do
contexts:
- context:
    cluster: yc-managed-k8s-catac9t0isbujgbo11do
    user: yc-managed-k8s-catac9t0isbujgbo11do
  name: yc-k8s-lab
current-context: yc-k8s-lab
kind: Config
preferences: {}
users:
- name: yc-managed-k8s-catac9t0isbujgbo11do
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - k8s
      - create-token
      - --profile=default
      command: /home/user/yandex-cloud/bin/yc
      env: null
      provideClusterInfo: false
[user@rocky9 lab-12]$ 





  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ../charts/kube-config"
  }

  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials ${self.name} --external --force --kubeconfig ../charts/kube-config"
  }