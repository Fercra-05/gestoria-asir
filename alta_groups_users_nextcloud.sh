#!/bin/bash

# ==============================================================================
# DESCRIPCIÓN:
# Este script recoge los usuarios creados y dados de alta y los asigna a un grupo
# Agrega los usuarios al grupo Gestoria y les asigna
# el correo electronico si no estuviese.
# ==============================================================================

# 1. Configuración del contenedor y del grupo
CONTENEDOR_NEXTCLOUD="nextcloud_app"
GRUPO="Gestoria"

# 2. Lista de usuarios (Solo necesitamos usuario y email)
USUARIOS=(
  "empleado1:empleado1@gestoria-asir.com"
  "empleado2:empleado2@gestoria-asir.com"
  "empleado3:empleado3@gestoria-asir.com"
  "empleado4:empleado4@gestoria-asir.com"
  "empleado5:empleado5@gestoria-asir.com"
)

echo "Iniciando la actualización de usuarios en NextCloud..."

# 3. Crear el grupo corporativo si no existe
docker exec --user www-data -i "$CONTENEDOR_NEXTCLOUD" \
  php /var/www/html/occ group:add "$GRUPO" 2>/dev/null
echo "Asegurando que el grupo '$GRUPO' existe..."
echo "----------------------------------------"

# 4. Bucle para procesar cada usuario
for item in "${USUARIOS[@]}"; do
  # Extraer usuario y correo
  IFS=':' read -r USER EMAIL <<< "$item"
  
  echo "Actualizando a $USER..."

  # Paso A: Asignar el correo electrónico
  docker exec --user www-data -i "$CONTENEDOR_NEXTCLOUD" \
    php /var/www/html/occ user:setting "$USER" settings email "$EMAIL" > /dev/null
    
  # Paso B: Añadir el usuario al grupo
  docker exec --user www-data -i "$CONTENEDOR_NEXTCLOUD" \
    php /var/www/html/occ group:adduser "$GRUPO" "$USER" > /dev/null
    
  echo "✅ $USER actualizado (email asignado y añadido al grupo '$GRUPO')."
  echo "----------------------------------------"
done

echo "Proceso finalizado con éxito."
