#! /bin/bash

SECONDS=$(date | awk '{ print $5 }' | cut -d ':' -f 3)

if ([ $SECONDS -gt 0 ] && [ $SECONDS -lt 6 ]) || ([ $SECONDS -gt 30 ] && [ $SECONDS -lt 36 ]);
then
	### Utilisation des disques ###	
	HOMEUSED=$(df -h /home | tail -1 | awk '{ print $5 }')
	ROOTUSED=$(df -h / | tail -1 | awk '{ print $5 }')
	echo "Disques:    / $ROOTUSED    HOME $HOMEUSED"

elif ([ $SECONDS -gt 5 ] && [ $SECONDS -lt 11 ]) || ([ $SECONDS -gt 35 ] && [ $SECONDS -lt 41 ]);
then
	### Noyau ###
	KERNEL=$(uname -sr)
	echo "Noyau: $KERNEL"

elif ([ $SECONDS -gt 10 ] && [ $SECONDS -lt 16 ]) || ([ $SECONDS -gt 40 ] && [ $SECONDS -lt 46 ]);
then
	### Utilisation du CPU ###
	VMSTAT=$(vmstat 1 1 | tail -1)
	CPUUSED=$(echo $VMSTAT | awk '{ print 100-$15"%"; }')
	CPUUSER=$(echo $VMSTAT | awk '{ print $13"%"; }')
	CPUSYS=$(echo $VMSTAT | awk '{ print $14"%"; }')
	CPUWAIT=$(echo $VMSTAT | awk '{ print $16"%"; }')
	echo "CPU: $CPUUSED ( U $CPUUSER    S $CPUSYS    W $CPUWAIT )"

elif ([ $SECONDS -gt 15 ] && [ $SECONDS -lt 21 ]) || ([ $SECONDS -gt 45 ] && [ $SECONDS -lt 51 ]);
then
	### Utilisation de la mémoire ###
	MEM=$(free -h | head -2 | tail -1 | awk '{ print $3"/"$2 }' | sed -e 's/i//g')
	MEMPERCENT=$(free -m | head -2 | tail -1 | awk '{ print "("int($3/$2*100) "%)" }' | sed -e 's/i//g')
	SWAP=$(free -h | tail -1 | awk '{ print $4"/"$3 }' | sed -e 's/i//g')
	SWAPPERCENT=$(free -m | tail -1 | awk '{ print "("int($4/$3*100) "%)" }' | sed -e 's/i//g')
	echo "Mémoire: $MEM $MEMPERCENT    Swap: $SWAP $SWAPPERCENT"

elif ([ $SECONDS -gt 20 ] && [ $SECONDS -lt 26 ]) || ([ $SECONDS -gt 50 ] && [ $SECONDS -lt 56 ]);
then
	### Charge ###
	LOAD=$(cat /proc/loadavg | awk '{ print $1"  " $2"  " $3 }')
	UPTIME=$(uptime | awk '{ print $3 }' | sed -e "s/:/h/" | sed -e "s/,//")
	echo "Charge: $LOAD   Uptime: $UPTIME""mn"
else
	### Utilisation réseau ###
	CNTIFACE=$(ip addr | grep BROADCAST -c)
	IFACE1=$(ifstat 0.1 1 | head -1 | awk '{ print $1 }')
	SPEED1=$(ifstat 0.1 1 | tail -1 | awk '{ print "Down:  "$1"  Up:  "$2  }')
	if [ $CNTIFACE -eq 2 ]
	then
		IFACE2=$(ifstat 0.1 1 | head -1 | awk '{ print $2 }')
		SPEED2=$(ifstat 0.1 1 | tail -1 | awk '{ print "Down:  "$3"  Up:  "$4  }')
		echo "$IFACE1 - $SPEED1     $IFACE2 - $SPEED2"
	else
		echo "$IFACE1 - $SPEED1"
	fi
fi

