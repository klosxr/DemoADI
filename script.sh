#!/bin/bash 

#SUBIR IMAGENES

openstack --insecure image create --disk-format qcow2 --container-format bare --file authC.qcow2 auth
openstack --insecure image create --disk-format qcow2 --container-format bare --file nfsC.qcow2 nfs
openstack --insecure image create --disk-format qcow2 --container-format bare --file blobC.qcow2 blob
openstack --insecure image create --disk-format qcow2 --container-format bare --file tokensC.qcow2 tokens
openstack --insecure image create --disk-format qcow2 --container-format bare --file balanC.qcow2 balanceador
openstack --insecure image create --disk-format qcow2 --container-format bare --file webC.qcow2 web
