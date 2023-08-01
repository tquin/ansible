#!/bin/bash

mcrcon_pass=$(<.mcrcon.pass)

function rcon {
  /srv/minecraft/mcrcon -H 127.0.0.1 -P 25575 -p "$mcrcon_pass" "$1"
}

rcon "stop"
