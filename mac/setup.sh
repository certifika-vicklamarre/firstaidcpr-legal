#!/bin/bash
# FirstAidCpr Mac bootstrap (fetched via GitHub Pages because the MacinCloud
# web-RDP keyboard cannot type https:// or uppercase). On the Mac:
#   curl --location -s certifika-vicklamarre.github.io/firstaidcpr-legal/mac/setup.sh -o fs.sh
#   bash fs.sh
# The Mac is shared with other projects: this script only ADDS things —
# a dedicated deploy key (a GitHub deploy key can belong to one repo only,
# so the existing default key stays untouched), an ssh config host alias,
# and the ~/firstaidcpr clone. It never modifies other projects' files.
set -e
log=~/firstaidcpr-bootstrap.log
{
  key=~/.ssh/id_firstaidcpr
  mkdir -p ~/.ssh
  if [ ! -f "$key" ]; then
    ssh-keygen -t ed25519 -N "" -f "$key" -C firstaidcpr-macincloud
  fi
  cfg=~/.ssh/config
  if ! grep -q github-firstaidcpr "$cfg" 2>/dev/null; then
    printf 'host github-firstaidcpr\n  hostname github.com\n  identityfile ~/.ssh/id_firstaidcpr\n  identitiesonly yes\n' >>"$cfg"
  fi
  echo "===== deploy key public part - add read-only on github ====="
  cat "$key.pub"
  echo "============================================================"
  ssh-keyscan github.com >>~/.ssh/known_hosts 2>/dev/null
  if [ ! -d ~/firstaidcpr ]; then
    git clone git@github-firstaidcpr:certifika-vicklamarre/firstaidcpr.git ~/firstaidcpr ||
      echo "clone failed - add the key above to the repo, then rerun this script"
  fi
  echo "bootstrap done"
} 2>&1 | tee "$log"
tail -8 "$log"
