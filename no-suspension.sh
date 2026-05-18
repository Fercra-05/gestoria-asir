#!/bin/bash
# Desactiva la suspensión del sistema por completo
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Configura el manejo de la tapa (Lid) para que no haga nada
sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf

# Reinicia el servicio de login para aplicar cambios
systemctl restart systemd-logind

echo "Configuración completada: El portátil ya no se suspenderá al cerrar la tapa."
