#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

doorman=192.168.1.101  # Fixed address given by permanent DHCP lease configured on Freebox router
# Port forwarding for ports 80 and 443 to 'doorman' is configured on the Freebox router

ssh $doorman mkdir -p ~/web-server/letsencrypt

rsync \
  --verbose \
  --recursive \
  --perms \
  --times \
  --delete \
  ./compose/ \
  $doorman:~/web-server/compose

# Using '--force-recreate' so that NGinx-Certbot picks up new sites and generates new certificates
ssh $doorman "cd web-server/compose; docker compose up --remove-orphans --force-recreate --detach"
