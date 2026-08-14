#!/bin/bash
# FirstAidCpr Mac bootstrap (fetched via GitHub Pages because the MacinCloud
# web-RDP keyboard cannot type https:// or uppercase). On the Mac:
#   curl --location -s certifika-vicklamarre.github.io/firstaidcpr-legal/mac/setup.sh -o s.sh
#   bash s.sh
# Generates a deploy key, prints it (the agent reads it on screen and adds it
# read-only to the github repo), then clones the app repo.
set -e
log=~/bootstrap.log
{
  key=~/.ssh/id_ed25519
  mkdir -p ~/.ssh
  if [ ! -f "$key" ]; then
    ssh-keygen -t ed25519 -N "" -f "$key" -C firstaidcpr-macincloud
  fi
  echo "===== deploy key public part - add read-only on github ====="
  cat "$key.pub"
  echo "============================================================"
  ssh-keyscan github.com >>~/.ssh/known_hosts 2>/dev/null
  if [ ! -d ~/firstaidcpr ]; then
    git clone git@github.com:certifika-vicklamarre/firstaidcpr.git ~/firstaidcpr ||
      echo "clone failed - add the key above to the repo, then rerun this script"
  fi
  echo "bootstrap done"
} 2>&1 | tee "$log"
tail -8 "$log"
