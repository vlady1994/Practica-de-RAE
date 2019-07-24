#aplicando filtros tc 

tc qdisc del dev eth0 ingress
tc qdisc add dev eth0 ingress handle ffff:

#aplicando reglas de flujo 1 tc para el ingreso de datos de la pc1 al r1
tc filter add dev eth0 parent ffff: \
	protocol ip prio 1 u32 \
	match ip src 102.0.0.10/24 \
	police rate 1.2Mbit burst 10k continue flowid :1

#aplicando reglas de flujo 3 tc para el ingreso de datos de la pc1 al r1
tc filter add dev eth0 parent ffff: \
	protocol ip prio 3 u32 \
	match ip src 102.0.0.10/24 \
	police rate 600kbit burst 10k continue flowid :3

###############################################
#aplicando siguientes flujos de salida para pc2
###############################################

#flujo 2
tc filter add dev eth0 parent ffff: \
	protocol ip prio 2 u32 \
	match ip src 102.0.0.20/24 \
	police rate 300kbit burst 10k continue flowid :2

#flujo 4
tc filter add dev eth0 parent ffff: \
	protocol ip prio 4 u32 \
	match ip src 102.0.0.20/24 \
	police rate 300kbit burst 10k continue flowid :4
#aplicando filtros tc 

tc qdisc del dev eth0 ingress
tc qdisc add dev eth0 ingress handle ffff:

#aplicando reglas de flujo 1 tc para el ingreso de datos de la pc1 al r1
tc filter add dev eth0 parent ffff: \
	protocol ip prio 1 u32 \
	match ip src 102.0.0.10/24 \
	police rate 1.2Mbit burst 10k continue flowid :1

#aplicando reglas de flujo 3 tc para el ingreso de datos de la pc1 al r1
tc filter add dev eth0 parent ffff: \
	protocol ip prio 3 u32 \
	match ip src 102.0.0.10/24 \
	police rate 600kbit burst 10k continue flowid :2

###############################################
#aplicando siguientes flujos de salida para pc2
###############################################

#flujo 2
tc filter add dev eth0 parent ffff: \
	protocol ip prio 2 u32 \
	match ip src 102.0.0.20/24 \
	police rate 300kbit burst 10k continue flowid :3

#flujo 4
tc filter add dev eth0 parent ffff: \
	protocol ip prio 4 u32 \
	match ip src 102.0.0.20/24 \
	police rate 300kbit burst 10k continue flowid :3
#declaramos el numero maximo de clases para las diferentes calidades

tc qdisc add dev eth1 root handle 1:0 dsmark indices 8

tc class change dev eth1 classid 1:1 dsmark mask 0x3 value 0x28

tc class change dev eth1 classid 1:2 dsmark mask 0x3 value 0x38

tc class change dev eth1 classid 1:3 dsmark mask  0x3 value 0x48

tc class change dev eth1 classid 1:4 dsmark mask 0x3 value 0x68


