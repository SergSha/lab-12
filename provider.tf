terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  #cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

provider "helm" {
  kubernetes {
    config_path = "./.kube/config"
  }
}
