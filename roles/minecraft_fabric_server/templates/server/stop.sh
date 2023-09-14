#!/bin/bash

mcrcon_pass=$(<.mcrcon.pass)
minecraft_dir="{{ minecraft_dir }}"

function rcon {
  "$minecraft_dir/mcrcon" -H 127.0.0.1 -P 25575 -p "$mcrcon_pass" "$1"
}

rcon "stop"
