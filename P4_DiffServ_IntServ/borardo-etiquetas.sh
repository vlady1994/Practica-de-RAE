#para el borrado de las marcas tenemos que hacer un diciplina de entrada

tc qdisc add dev eth0 handle ffff: ingress

tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src  102.0.0.10/24 flowid :1
tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src  102.0.0.20/24 flowid :2
tc filter add dev eth0 parent ffff: protocol ip prio 1 u32 match ip src  103.0.0.30/24 flowid :3

#ahora aplicamos el borrado de salida

tc qdisc add dev eth1 root handle 1:0 dsmark indices 8

tc class change dev eth1 classid 1:1 dsmark mask 0x0 value 0x00
tc class change dev eth1 classid 1:2 dsmark mask 0x0 value 0x00
tc class change dev eth1 classid 1:3 dsmark mask 0x0 value 0x00

tc filter add dev eth1 parent 1:0 protocol ip prio 1 handle 1 tcindex classid 1:1
tc filter add dev eth1 parent 1:0 protocol ip prio 1 handle 1 tcindex classid 1:2
tc filter add dev eth1 parent 1:0 protocol ip prio 1 handle 1 tcindex classid 1:3
