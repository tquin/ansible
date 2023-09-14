#!/bin/bash

minecraft_dir="{{ minecraft_dir }}"

# 1GB
/usr/bin/java -Xms1024M -Xmx1024M -jar "$minecraft_dir/server.jar" nogui
