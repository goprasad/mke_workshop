#!/usr/bin/env bash

dcos security org groups create kubernetes-users
dcos security org group grant kubernetes-users dcos:adminrouter:ops:mesos full
dcos security org groups grant kubernetes-users dcos:adminrouter:ops:slave full
dcos security org groups grant kubernetes-users dcos:adminrouter:package full
dcos security org groups grant kubernetes-users dcos:adminrouter:service:marathon full
dcos security org groups grant kubernetes-users dcos:adminrouter:service:nginx full