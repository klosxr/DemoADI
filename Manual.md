

# Despliegue de Microservicios Distribuidos

Manual para instalación y despliegue automático de un sistema de microservicios distribuidos.

## Índice

- [Despliegue de Microservicios Distribuidos](#despliegue-de-microservicios-distribuidos)
- [Instalación plataforma (OpenStack)](#instalación-plataforma-openstack)
  - [1º Crear VM NodoDirector, VM NodoWorker y VM jumpstart](#1º-crear-vm-nododirector-vm-nodoworker-y-vm-jumpstart)
  - [2º Instalar OpenStack(VM)](#2º-instalar-openstackvm)
- [Despliegue en plataforma (jumpstart) (OpenStack)](#despliegue-en-plataforma-jumpstart-openstack)
  - [1º Clonar el repositorio](#1º-clonar-el-repositorio)
  - [2º Dar permisos a scripts](#2º-dar-permisos-a-scripts)
  - [3º Desplegar](#3º-desplegar)

## Instalación plataforma (OpenStack)

### 1º Crear VM NodoDirector, VM NodoWorker y VM jumpstart

### 2º Instalar OpenStack(VM):
-En nodo director (control node):
```
sudo apt install git python3 python3-pip -y

sudo snap install microstack --beta

sudo microstack init --auto --control

[4.1] (OBTENER CONTRASEÑA)
sudo snap get microstack config.credentials.keystone-password

[4.2] (Obtener Token para añadir Nodo computo (worker)
sudo microstack add-compute
```
-En nodo worker (compute node):
```
sudo apt install git python3 python3-pip -y

sudo snap install microstack --beta

sudo microstack init
    Rellenar las preguntas que piden
        -Seleccionar Compute Node
        -Indicar la IP del nodo de control
        -Añadir el token que se obtuvo en [4.2]
```


## Despliegue en plataforma (jumpstart) (OpenStack)

Antes de nada, desde el navegador, acceder al panel de control de OpenStack introduciendo en la barra de búsqueda la ip del nodo director y descargar archivo admin-openrc.sh

Ejecutar
```
source admin-openrc.sh
```
Introducir la contraseña de keystone obtenida en [4.1]


### 1º Clonar el repositorio

```
git clone https://github.com/klosxr/DemoADI/
```
### 2º Dar permisos a scripts:
```
chmod 777 deploy.sh
chmod 777 script.sh
chmod 777 script2.sh
```

### 3º Desplegar
```
./deploy.sh
```
Esperar a que finalize el despliegue automático que incluye (subida de imagenes (script.sh) + instancias y configuración (script2.sh)

