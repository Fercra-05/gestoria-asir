#!/bin/bash

# ==============================================================================
# DESCRIPCIÓN:
# Este script automatiza la creación de múltiples usuarios en sistemas Linux
# asignándoles contraseñas específicas de forma masiva y silenciosa.
#
# FUNCIONAMIENTO:
# 1. Seguridad: Verifica si el script se está ejecutando con privilegios de administrador
#    (root), lo cual es un requisito indispensable para poder crear nuevos usuarios.
# 2. Configuración de datos: Utiliza una matriz (array) llamada 'USUARIOS' que almacena 
#    pares de datos con el formato "nombre_usuario:contraseña".
# 3. Ejecución (Bucle principal): Recorre cada elemento de la matriz y realiza lo siguiente:
#    - Divide el texto en dos variables separadas ('USER' y 'PASS') usando los dos puntos (:) como separador.
#    - Comprueba en el sistema si el usuario ya está registrado para evitar duplicados.
#    - Si el usuario es nuevo, lo crea junto con su carpeta personal (home) y le asigna Bash.
#    - Pasa la contraseña mediante una tubería (pipe) al comando 'chpasswd' para establecerla sin pedir confirmación manual.
# ==============================================================================


# 1. Comprobar si el script se está ejecutando con permisos de root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Por favor, ejecuta este script como root (ej: sudo ./crear_usuarios.sh)"
  exit 1
fi

# 2. Definir la lista de usuarios y contraseñas (formato usuario:contraseña)
USUARIOS=(
  "empleado1:ClaveSegura1!"
  "empleado2:Password_2026"
  "empleado3:MiSecreto#3"
  "empleado4:LinuxUser4$"
  "empleado5:Acces0*cinco"
)

# 3. Bucle para procesar cada elemento de la lista
for item in "${USUARIOS[@]}"; do
  # Extraer el nombre de usuario (todo lo que está antes de los dos puntos)
  USER="${item%%:*}"
  # Extraer la contraseña (todo lo que está después de los dos puntos)
  PASS="${item##*:}"

  # Comprobar si el usuario ya existe en el sistema
  if id "$USER" &>/dev/null; then
    echo "El usuario '$USER' ya existe. Saltando..."
  else
    # Crear el usuario con su directorio home (-m) y bash como terminal por defecto (-s)
    useradd -m -s /bin/bash "$USER"
    
    # Asignar la contraseña de forma silenciosa usando chpasswd
    echo "$USER:$PASS" | chpasswd
    
    # Verificar si el comando anterior fue exitoso
    if [ $? -eq 0 ]; then
      echo "✅ Usuario '$USER' creado correctamente."
    else
      echo "❌ Error al crear el usuario '$USER'."
    fi
  fi
done

echo "Proceso finalizado."
