

#a)
#borrar la tabla filter, su contenido y reiniciar sus contradores.
iptables -t filter -F
iptables -t filter -Z

#b)
#politicas por defecto descarta todo trafico al Firewall y acepta el trafico saliente
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT ACCEPT

#partiendo del script fw1.sh
#lo que se hizo en el script fw1.sh, reglas para aplicar nateo en el Firewall.
iptables -t nat -A POSTROUTING -s 10.6.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2
iptables -t nat -A POSTROUTING -s 10.7.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2
iptables -t nat -A POSTROUTING -s 10.8.22.0/24 -o eth2 -j SNAT --to-source 10.4.22.2

#c)
#con esto se esta permitiendo el trafico dirigido a las app que estan ejecutando den el
#Firewall, tienen que provenir de las subredes privadas.

iptables -t filter -A INPUT -s 10.1.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.2.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.3.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.4.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.6.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.7.22.0/24 -j ACCEPT
iptables -t filter -A INPUT -s 10.8.22.0/24 -j ACCEPT

#d)
#se permite el trafico saliente subres privada hacia internet:SNAT en scrip fw1.sh
#permite el reenvio de todos los paquetes que recibe el router atraves de la interfaz
#eth0 para que se envie por la interfaz eth2
iptables -t filter -A FORWARD -i eth0 -o eth2 -j ACCEPT

#permite el reenvio paquetes entrantes que pertenecen a una conexion ya establecida
iptables -t filter -A FORWARD -i eth2 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#antes ya se habia establecido la conexion de la red privada a internet->
iptables -t filter -A FORWARD -i eth1 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
#antes ya se habia establecido la conexion de la red internet a DMZ->
iptables -t filter -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#antes ya se habia establecido la conexion de la red privada a DMZ<-

#e)
#permitir trafico de internet hacia la DMZ cuando se dirige a un puerto y pc destino.
#el server ECHO instalado en PC4(UDP,port 7)
#en la tabla filter le aplico la cadena FORWARD(paquetes que entran al Firewall pero que van destinado a otra maquina,se ejecuta antes de consultar la tabla de encaminamiento)
iptables -t filter -A FORWARD -i eth2 -d 10.5.22.2 -o eth1 -p udp --dport 7 -j ACCEPT
#el server daytime instalado en PC5(TCP,port 13)
iptables -t filter -A FORWARD -i eth2 -d 10.5.22.3 -o eth1 -p udp --dport 13 -j ACCEPT

#f)
#permitir conexion de la red privada a la zona DMZ:
#conexion telnet(TCP, puerto 13) desde PC1 a PC5
iptables -t filter -A FORWARD -i eth0 -s 10.7.22.3 -d 10.5.22.3 -p tcp --dport 23 -j ACCEPT
iptables -t filter -A FORWARD -i eth2 -s 10.1.22.2 -d 10.5.22.3 -p tcp --dport 23 -j ACCEPT
#conexion ECHO(TCP,port 7) desde PC1 a PC4
iptables -t filter -A FORWARD -i eth0 -s 10.7.22.3 -d 10.5.22.2 -p tcp --dport 7 -j ACCEPT

#g)
#eliminando comunicacion de la zona DMZ a la red privada y al Firewall.
iptables -t filter -A FORWARD -s 10.5.22.2 -d 10.7.22.0/24 -j DROP
iptables -t filter -A FORWARD -s 10.5.22.3 -d 10.7.22.0/24 -j DROP

iptables -t filter -A FORWARD -s 10.5.22.2 -d 10.8.22.0/24 -j DROP
iptables -t filter -A FORWARD -s 10.5.22.3 -d 10.8.22.0/24 -j DROP

iptables -t filter -A FORWARD -s 10.5.22.2 -d 10.6.22.0/24 -j DROP
iptables -t filter -A FORWARD -s 10.5.22.3 -d 10.6.22.0/24 -j DROP
