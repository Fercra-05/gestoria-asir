#!/bin/bash

echo "--- Iniciando limpieza profunda de Docker ---"

# 1. Detener procesos y servicios
echo "1. Deteniendo servicios..."
systemctl --user stop docker-desktop
systemctl stop docker docker.socket containerd
systemctl --user unmask docker-desktop 2>/dev/null

# 2. Matar procesos residuales de Docker Desktop (QEMU, Backend)
echo "2. Eliminando procesos huérfanos..."
sudo killall -9 docker-desktop com.docker.backend qemu-system-x86_64 2>/dev/null

# 3. Desinstalar paquetes de Docker Desktop y Engine
echo "3. Desinstalando paquetes..."
sudo apt-get purge -y docker-desktop docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io
sudo apt-get autoremove -y --purge

# 4. Borrar archivos de configuración del Sistema (Root)
echo "4. Borrando directorios de sistema..."
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf /usr/libexec/docker/cli-plugins/docker-compose
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

# 5. Borrar archivos de configuración de Usuario (MUY IMPORTANTE para Desktop)
echo "5. Borrando configuraciones de usuario..."
rm -rf ~/.docker
rm -rf ~/.config/main.js
rm -rf ~/.local/share/docker-desktop
rm -rf ~/.config/systemd/user/docker-desktop.service
rm -rf ~/.config/systemd/user/default.target.wants/docker-desktop.service

# 6. Limpiar sockets y archivos temporales
echo "6. Limpiando sockets y temporales..."
sudo rm -f /var/run/docker.sock
rm -f /tmp/.docker*
rm -f ~/.docker/desktop/p9s.sock

echo "--- Limpieza completada ---"
echo "Se recomienda reiniciar el sistema antes de una nueva instalación."
