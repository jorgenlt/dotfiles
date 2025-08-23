#!/bin/bash
# remove-open-webui.sh
# Completely remove Open WebUI (containers, images, volumes, networks, data)

echo "Stopping Open WebUI containers..."
docker stop $(docker ps -a -q --filter "name=open-webui") 2>/dev/null

echo "Removing Open WebUI containers..."
docker rm $(docker ps -a -q --filter "name=open-webui") 2>/dev/null

echo "Removing Open WebUI images..."
docker rmi $(docker images -q --filter "reference=*open-webui*") 2>/dev/null

echo "Removing Open WebUI volumes..."
docker volume rm $(docker volume ls -q --filter "name=open-webui") 2>/dev/null

echo "Removing Open WebUI networks..."
docker network rm $(docker network ls -q --filter "name=open-webui") 2>/dev/null

echo "Removing local Open WebUI folder (if exists)..."
rm -rf ~/open-webui

echo "✅ Open WebUI has been completely removed."
