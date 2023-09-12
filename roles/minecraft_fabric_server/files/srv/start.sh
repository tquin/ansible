#!/bin/bash

cd /srv/minecraft
# 1GB
/usr/bin/java -Xms1024M -Xmx1024M -jar /srv/minecraft/server.jar nogui
