#borramos diciplinas de colas existentes
tc qdisc del dev eth2 root

#se define un numero maximo de narcas para las calidades
#en este caso solo son 4 calidades, pero aplicamos 8 , por si se desea agragar una calidad mas.
tc qdisc add dev eth2 root handle 1:0 dsmark indices 8 set_tc_index

#aqui se se obtiene la marca que llega al r3, por medio de la tcindex
tc filter add dev eth2 parent 1:0 protocol ip prio 1 tcindex mask 0xfc shift 2

#definimos una subclase 2:0 htb, decendiente de las marcas de indices 1:0
tc qdisc add dev eth2 parent 1:0 handle 2:0 htb
tc class add dev eth2 parent 2:0 classid 2:1 htb rate 2.4Mbit
 
#se establece el flujo minimo y maximo para cada calidad

tc class add dev eth2 parent 2:1 classid 2:10 htb rate 1Mbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:11 htb rate 500kbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:12 htb rate 400kbit ceil 2.4Mbit
tc class add dev eth2 parent 2:1 classid 2:13 htb rate 200kbit ceil 2.4Mbit

#cambiamos la etiqueta de la calidad 1 a 0x12 ==> AF21 ==> 0x48
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x12 tcindex classid 2:10
#cambiamos la etiqueta de la calidad 2 a 0x0a ==> AF11 ==> 0x28
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x0a tcindex classid 2:11
#cambiamos la etiqueta de la calidad 1 a 0x1a ==> AF31 ==> 0x68
tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x1a tcindex classid 2:12
#cambiamos la etiqueta de la calidad 1 a 0x12 ==> AF41 ==> 0x88
#tc filter add dev eth2 parent 2:0 protocol ip prio 1 handle 0x12 tcindex classid 2:13
