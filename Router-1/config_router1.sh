#!/bin/bash
# =============================================
# Script para configurar interfaces de red y DHCP relay
# =============================================

echo "=== CONFIGURACIÓN DE RED - ¡CUIDADO! ==="
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

## INTERNET
allow-hotplug enp0s3
iface enp0s3 inet dhcp

## LAN 0.0
allow-hotplug enp0s8
iface enp0s8 inet static
        address 10.0.0.1
        netmask 255.255.255.0

## LAN 10.0
allow-hotplug enp0s9
iface enp0s9 inet static
        address 10.0.10.1
        netmask 255.255.255.0

up ip route add 10.0.20.0/24 via 10.0.10.2 dev enp0s9
down ip route del 10.0.20.0/24 via 10.0.10.2 dev enp0s9
up ip route add 10.0.30.0/24 via 10.0.10.3 dev enp0s9
down ip route del 10.0.30.0/24 via 10.0.10.3 dev enp0s9
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
