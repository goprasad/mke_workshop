#!/usr/bin/env bash

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/mke-workshop
ssh-add ~/dcos_scripts/ccm.pem