
#borar la tabla filter 
iptables -t filter -F
iptables -t filter -Z
#Reglas para aplicar nateo en firewall

iptables -t nat -A POSTROUTING -s 10.6.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2
iptables -t nat -A POSTROUTING -s 10.7.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2
iptables -t nat -A POSTROUTING -s 10.8.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2

