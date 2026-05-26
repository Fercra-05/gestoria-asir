#!/bin/bash

# ==============================================================================
# DESCRIPCIÓN:
# Crea usuarios masivamente en una instancia de NextCloud en Docker,
# utilizando su herramienta oficial de consola (occ).
# ==============================================================================

# 1. Configuración del contenedor
# ¡IMPORTANTE! Cambia esto por el nombre real de tu contenedor de NextCloud
CONTENEDOR_NEXTCLOUD="nextcloud_app"

# 2. Lista de usuarios (Formato -> usuario:contraseña:nombre:apellido:email)
USUARIOS=(
  "empleado1:ClaveSegura1!:Ana:García:empleado1@gestoria-asir.com"
  "empleado2:Password_2026:Luis:Pérez:empleado2@gestoria-asir.com"
  "empleado3:MiSecreto#3:Carlos:López:empleado3@gestoria-asir.com"
  "empleado4:LinuxUser4$:Marta:Sánchez:empleado4@gestoria-asir.com"
  "empleado5:Acces0*cinco:Elena:Martín:empleado5@gestoria-asir.com"
)

echo "Iniciando la creación de usuarios en NextCloud (Contenedor: $CONTENEDOR_NEXTCLOUD)..."

# 3. Bucle para procesar cada elemento
for item in "${USUARIOS[@]}"; do
  # Extraer los datos
  IFS=':' read -r USER PASS NOMBRE APELLIDO EMAIL <<< "$item"
  
  # Unir nombre y apellido para el "Display Name" de NextCloud
  NOMBRE_COMPLETO="$NOMBRE $APELLIDO"

  echo "Procesando a $USER..."

  # Paso A: Crear el usuario con su contraseña y nombre visible
  # Nota: Usamos el usuario 'www-data' que es el dueño de la web en Linux
  docker exec --user www-data -e OC_PASS="$PASS" -i "$CONTENEDOR_NEXTCLOUD" \
    php /var/www/html/occ user:add --password-from-env --display-name="$NOMBRE_COMPLETO" "$USER"

  if [ $? -eq 0 ]; then
    # Paso B: Si se creó bien, le asignamos el correo electrónico
    docker exec --user www-data -i "$CONTENEDOR_NEXTCLOUD" \
      php /var/www/html/occ user:setting "$USER" settings email "$EMAIL" > /dev/null
      
    echo "✅ $USER creado correctamente en NextCloud."
  else
    echo "❌ Error al crear a $USER."
  fi
  echo "----------------------------------------"
done

echo "Proceso finalizado."
