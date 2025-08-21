#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

doorman=192.168.1.101  # Fixed address given by permanent DHCP lease configured on Freebox router
# Port forwarding for ports 80 and 443 to 'doorman' is configured on the Freebox router

ssh $doorman mkdir -p ~/web-server/letsencrypt ~/web-server/patty/classification-models

rsync \
  --verbose \
  --recursive \
  --perms \
  --times \
  --delete \
  ./compose/ \
  $doorman:~/web-server/compose

# Add '--force-recreate' when added a new site so that NGinx-Certbot generates new certificates on startup
ssh $doorman "cd web-server/compose; docker compose up --remove-orphans --detach"
# ssh $doorman "cd web-server/compose; docker compose exec --workdir /app/patty patty-backend alembic upgrade head"
# ssh $doorman "cd web-server/compose; docker compose exec patty-backend python -m patty migrate-data"
