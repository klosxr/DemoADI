#!/bin/bash 

#INSTANCIAS y CONFIGURACION

#red interna
openstack --insecure network create red-interna
openstack --insecure subnet create --network red-interna --subnet-range 192.168.58.0/24 --no-dhcp red-interna-subnet 

#red externa
openstack --insecure network create red-externa --share --provider-network-type flat --provider-physical-network physnet1
openstack --insecure subnet create red-externa-subnet --network red-externa --subnet-range 10.20.20.0/24 --gateway 10.20.20.1 --allocation-pool start=10.20.20.2,end=10.20.20.10 --dns-nameserver 8.8.8.8


#puertos IPs fijas

openstack --insecure port create --network red-interna --fixed-ip subnet=red-interna-subnet,ip-address=192.168.58.6 nfs-port
openstack --insecure port create --network red-interna --fixed-ip subnet=red-interna-subnet,ip-address=192.168.58.5 web-port
openstack --insecure port create --network red-interna --fixed-ip subnet=red-interna-subnet,ip-address=192.168.58.2 auth-port
openstack --insecure port create --network red-interna --fixed-ip subnet=red-interna-subnet,ip-address=192.168.58.3 tokens-port
openstack --insecure port create --network red-interna --fixed-ip subnet=red-interna-subnet,ip-address=192.168.58.4 blob-port

#reglas de seguridad
openstack --insecure security group create --description "Seguridad" full-sec
openstack --insecure security group rule create --proto tcp --dst-port 80 --ingress full-sec
openstack --insecure security group rule create --proto tcp --dst-port 443 --ingress full-sec
openstack --insecure security group rule create --proto tcp --dst-port 22 --ingress full-sec
openstack --insecure security group rule create --proto icmp --ingress full-sec
openstack --insecure security group rule create --proto icmp --egress full-sec
openstack --insecure security group rule create --remote-group full-sec --ingress full-sec
openstack --insecure security group rule create --remote-group full-sec --egress full-sec


#crear instancias
openstack --insecure server create --image balanceador --flavor m1.small.6gb --nic "net-id=$(openstack --insecure network show red-externa -c id -f value),v4-fixed-ip=10.20.20.9" --nic "net-id=$(openstack --insecure network show red-interna -c id -f value),v4-fixed-ip=192.168.58.10" --hint force_hosts=director balan

openstack --insecure server create --image nfs --flavor m1.small.8gb --port nfs-port --security-group full-sec nfs
openstack --insecure server create --image auth --flavor m1.small.6gb --port auth-port --security-group full-sec auth
openstack --insecure server create --image tokens --flavor m1.small.6gb --port tokens-port --security-group full-sec tokens
openstack --insecure server create --image blob --flavor m1.small.6gb --port blob-port --security-group full-sec blob
openstack --insecure server create --image web --flavor m1.small.6gb --port web-port --security-group full-sec web

#por si acaso no se añade correctamente el grupo de seguridad al crear la instancia
openstack --insecure server add security group nfs full-sec
openstack --insecure server add security group auth full-sec
openstack --insecure server add security group tokens full-sec
openstack --insecure server add security group blob full-sec
openstack --insecure server add security group web full-sec
openstack --insecure server add security group balan full-sec



echo "Balanceador accesible en: http://10.20.20.9"

echo "Despliegue completado!"







