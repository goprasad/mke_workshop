#!/usr/bin/env bash
# $1 - Team number
set -x
dcos security org users create -d "MKE$1 User" -p "mesosphere" mke$1
dcos security org groups add_user kubernetes-users mke$1
dcos security org users grant mke$1 dcos:service:marathon:marathon:services:/kubernetes-cluster$1 full

