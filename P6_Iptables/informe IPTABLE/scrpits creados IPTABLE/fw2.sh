#!/bin/bash
# "Se borran reglas anteriores"
iptables -t nat -F
# "Reiniciar contadores de una cadena"
iptables -t nat -Z

#se estan aplicando nuevas traducciones DNAT
#estoy indicando que todo paquete que llega al Firewall a la interfaz eth2 con un puerto destino
#sera destinado a una IP y sera dirigido con otro puerto a esa IP.
iptables -t nat -A PREROUTING -p udp -i eth2 --dport 5001 -j DNAT --to-destination 10.7.22.3:5001
iptables -t nat -A PREROUTING -p udp -i eth2 --dport 5002 -j DNAT --to-destination 10.7.22.2:5001

#aca se estara aplicando un DNAT al trafico con destino al puerto 80 TCP, este sera redirigido a
#la PC3, puerto 80.
iptables -t nat -A PREROUTING -p tcp -i eth2 --dport 80 -j DNAT --to-destination 10.8.22.2:80
