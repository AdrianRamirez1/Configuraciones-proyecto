#!/bin/bash
# =============================================
# Script para Servidor DHCP (Primary)
# =============================================

echo "=== CONFIGURACIÓN SERVIDOR DHCP - ¡CUIDADO! ==="
echo "Este script va a SOBRESCRIBIR completamente:"
echo "   • /etc/network/interfaces"
echo "   • /etc/default/isc-dhcp-server"
echo "   • /etc/dhcp/dhcpd.conf"
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
        address 10.0.0.10
        netmask 255.255.255.0
        gateway 10.0.0.1
EOF

# ==================== /etc/default/isc-dhcp-server ====================
echo "Escribiendo configuración en /etc/default/isc-dhcp-server..."

sudo tee /etc/default/isc-dhcp-server > /dev/null << 'EOF'
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)
# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf
# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid
# Additional options to start dhcpd with.
# Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="enp0s3"
INTERFACESv6=""
EOF

# ==================== /etc/dhcp/dhcpd.conf ====================
echo "Escribiendo configuración en /etc/dhcp/dhcpd.conf..."

sudo tee /etc/dhcp/dhcpd.conf > /dev/null << 'EOF'
# dhcpd.conf
option domain-name "lexlegal.com";
option domain-name-servers ns1.lexlegal.com;
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;
authoritative;

# FAILOVER
# PRIMARY:
failover peer "lex.fallos" {
 primary;
 address 10.0.0.10;
 port 647;
 peer address 10.0.0.11;
 peer port 647;
 max-response-delay 30;
 max-unacked-updates 10;
 load balance max seconds 3;
 mclt 3600;
 split 128;
}

# SUBNET-0
subnet 10.0.0.0 netmask 255.255.255.0{
 pool{
  range 10.0.0.100 10.0.0.200;
  failover peer "lex.fallos";
  option routers 10.0.0.1;
 }
}

# SUBNET-10
subnet 10.0.10.0 netmask 255.255.255.0{
 pool{
  range 10.0.10.100 10.0.10.200;
  failover peer "lex.fallos";
  option routers 10.0.10.1;
 }
}

# SUBNET-20
subnet 10.0.20.0 netmask 255.255.255.0{
 pool{
  range 10.0.20.100 10.0.20.200;
  failover peer "lex.fallos";
  option routers 10.0.20.1;
 }
}

# SUBNET-30
subnet 10.0.30.0 netmask 255.255.255.0{
 pool{
  range 10.0.30.100 10.0.30.200;
  failover peer "lex.fallos";
  option routers 10.0.30.1;
 }
}
EOF

echo ""
echo "✅ Archivos de configuración actualizados correctamente."
echo ""

# Reinicios de servicios
echo "Reiniciando servicios..."
sudo systemctl restart networking.service
sudo systemctl restart isc-dhcp-server

echo ""
echo "✅ Reinicios ejecutados:"
echo "   • systemctl restart networking.service"
echo "   • systemctl restart isc-dhcp-server"
echo ""

echo "Verifica el estado con:"
echo "   ip addr show"
echo "   systemctl status isc-dhcp-server"
echo "   sudo dhcpd -t -cf /etc/dhcp/dhcpd.conf   # (para comprobar sintaxis)"

echo ""
echo "¡Script finalizado!"
