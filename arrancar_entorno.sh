#!/bin/bash

# Colores para que la terminal se vea profesional
VERDE='\033[0;32m'
AZUL='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${AZUL}--- Iniciando infraestructura ASIR ---${NC}"

# 1. Aseguramos que el motor de Docker esté vivo
sudo systemctl start docker.socket
sudo systemctl start docker

# 2. Levantamos los contenedores en segundo plano
echo -e "${VERDE}[1/3] Levantando contenedores con Docker Compose...${NC}"
docker compose up -d

# 3. Esperamos unos segundos a que Moodle esté listo
sleep 5

# 4. Arrancamos Apache dentro del contenedor de Moodle
echo -e "${VERDE}[2/3] Iniciando Apache en el servidor Moodle...${NC}"
docker exec -it moodle_server service apache2 start

# 5. Verificamos que todo esté UP
echo -e "${VERDE}[3/3] Estado actual del sistema:${NC}"
docker ps

echo -e "${AZUL}--- ¡Todo listo! Accede a tus dominios ---${NC}"
