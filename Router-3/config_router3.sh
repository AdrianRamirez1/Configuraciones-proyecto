#!/bin/bash
# =============================================
# Script para Router2 - Configuración de red y DHCP relay
# =============================================

echo "=== CONFIGURACIÓN DE RED ROUTER2 - ¡CUIDADO! ==="
echo "Este script va a SOBRESCRIBIR completamente:"
echo "   • /etc/network/interfaces"
echo "   • /etc/default/isc-dhcp-relay"
echo ""
read -p "¿Estás seguro de continuar? (s/N): " confirm

if [[ $confirm != [sS] ]]; then
    echo "Operación cancelada por el usuario."
    exit 1
fi

# ==================== /etc/network/interfaces ====================
echo "Escribiendo configuración en /etc/network/interfaces..."

sudo tee /etc/network/interfaces > /dev/null << 'EOF'
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

## LAN 10
allow-hotplug enp0s3
iface enp0s3 inet static
        address 10.0.10.3
        netmask 255.255.255.0
        gateway 10.0.10.1

## LAN 30
allow-hotplug enp0s8
iface enp0s8 inet static
        address 10.0.30.1
        netmask 255.255.255.0

up ip route add 10.0.0.0/24 via 10.0.10.1 dev enp0s3
down ip route del 10.0.0.0/24 via 10.0.10.1 dev enp0s3
up ip route add 10.0.20.0/24 via 10.0.10.1 dev enp0s3
down ip route del 10.0.20.0/24 via 10.0.10.1 dev enp0s3
EOF

# ==================== /etc/default/isc-dhcp-relay ====================
echo "Escribiendo configuración en /etc/default/isc-dhcp-relay..."

sudo tee /etc/default/isc-dhcp-relay > /dev/null << 'EOF'
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts
#
# This is a POSIX shell fragment
#
# What servers should the DHCP relay forward requests to?
SERVERS="10.0.0.10 10.0.0.11"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES=""

# Additional options that are passed to the DHCP relay daemon?
OPTIONS="enp0s8 enp0s3"
EOF

echo ""
echo "✅ Archivos de configuración actualizados correctamente."
echo ""

# Reinicios de servicios
echo "Reiniciando servicios de red..."
sudo systemctl restart networking.service
sudo systemctl restart isc-dhcp-relay

echo ""
echo "✅ Reinicios ejecutados:"
echo "   • systemctl restart networking.service"
echo "   • systemctl restart isc-dhcp-relay"
echo ""

echo "Verifica el estado con:"
echo "   ip addr show"
echo "   ip route"
echo "   systemctl status isc-dhcp-relay"

echo ""
echo "¡Script finalizado!"
