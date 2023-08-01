#!/bin/bash

level_name=$(<.world.name)
mcrcon_pass=$(<.mcrcon.pass)

function rcon {
  /srv/minecraft/mcrcon -H 127.0.0.1 -P 25575 -p "$mcrcon_pass" "$1"
}

rcon "save-off"

rcon "save-all"

tar -cvpzf "/srv/minecraft/backups/$level_name/backup-$(date +%F-%H-%M).tar.gz" "/srv/minecraft/$level_name/"

rcon "save-on"

## Delete older backups

find /srv/minecraft/backups/ -type f -mtime +7 -name '*.gz' -delete
