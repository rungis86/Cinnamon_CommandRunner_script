#! /bin/bash

utilisation_des_disques(){
        HOMEUSED=$(df -h /home | tail -1 | awk '{ print $5 }')
        ROOTUSED=$(df -h / | tail -1 | awk '{ print $5 }')
        echo "Disques:    / $ROOTUSED    HOME $HOMEUSED"
}

noyau(){
        KERNEL=$(uname -sr)
        echo "Noyau: $KERNEL"
}

utilisation_cpu(){
        VMSTAT=$(vmstat 1 1 | tail -1)
        CPUUSED=$(echo "$VMSTAT" | awk '{ print 100-$15"%"; }')
        CPUUSER=$(echo "$VMSTAT" | awk '{ print $13"%"; }')
        CPUSYS=$(echo "$VMSTAT" | awk '{ print $14"%"; }')
        CPUWAIT=$(echo "$VMSTAT" | awk '{ print $16"%"; }')
        echo "CPU: $CPUUSED ( U $CPUUSER    S $CPUSYS    W $CPUWAIT )"
}

utilisation_memoire(){
        MEM=$(free -h | head -2 | tail -1 | awk '{ print $3"/"$2 }' | sed -e 's/i//g')
        MEMPERCENT=$(free -m | head -2 | tail -1 | awk '{ print "("int($3/$2*100) "%)" }' | sed -e 's/i//g')
        SWAP=$(free -h | tail -1 | awk '{ print $4"/"$3 }' | sed -e 's/i//g')
        SWAPPERCENT=$(free -m | tail -1 | awk '{ print "("int($4/$3*100) "%)" }' | sed -e 's/i//g')
        echo "Mémoire: $MEM $MEMPERCENT    Swap: $SWAP $SWAPPERCENT"
}

charge(){
        LOAD=$(< /proc/loadavg awk '{ print $1"  " $2"  " $3 }')
        UPTIME=$(uptime | awk '{ print $3 }' | sed -e "s/:/h/" | sed -e "s/,//")
        echo "Charge: $LOAD   Uptime: $UPTIME""mn"
}

utilisation_reseau(){
        CNTIFACE=$(ip addr | grep BROADCAST -c)
        IFACE1=$(ifstat 0.1 1 | head -1 | awk '{ print $1 }')
        SPEED1=$(ifstat 0.1 1 | tail -1 | awk '{ print "Down:  "$1"  Up:  "$2  }')
        if (( CNTIFACE == 2 ));then
		IFACE2=$(ifstat 0.1 1 | head -1 | awk '{ print $2 }')
                SPEED2=$(ifstat 0.1 1 | tail -1 | awk '{ print "Down:  "$3"  Up:  "$4  }')
                echo "$IFACE1 - $SPEED1     $IFACE2 - $SPEED2"
        else
                echo "$IFACE1 - $SPEED1"
        fi
}

main(){
        SECONDS=$(date | awk '{ print $5 }' | cut -d ':' -f 3)

        if (( SECONDS >= 0 && SECONDS <= 4 )) || (( SECONDS >= 30 && SECONDS <= 34 ));then
                utilisation_des_disques

        elif (( SECONDS >= 5 && SECONDS <= 9 )) || (( SECONDS >= 35 && SECONDS <= 39 ));then
                noyau

        elif (( SECONDS >= 10 && SECONDS <= 14 )) || (( SECONDS >= 40 && SECONDS <= 44 ));then
                utilisation_cpu

        elif (( SECONDS >= 15 && SECONDS <= 19 )) || (( SECONDS >= 45 && SECONDS <= 49 ));then
                utilisation_memoire

        elif (( SECONDS >= 20 && SECONDS <= 24 )) || (( SECONDS >= 50 && SECONDS <= 54 ));then
                charge

        else
                utilisation_reseau
        fi
}

main
