#!/bin/sh

#### RECUPERATION PARAMETRES SUR FICHIER DE CONF
####
if [ "$1" == "" ]  ###CONTROLE DES ARGUMENTS
    then
        echo "CONFIG FILE REQUIRED"
        exit
    else
        source $1
fi

name=$(curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" --request GET  http://$MOXA_IP/api/slot/0/sysInfo/device | awk '{split($0,a,",");  print a[3]}' | tr -d '"' | awk '{split($0,b,":");  print b[2]}')
serial=$SERIAL
if [ -f "/tmp/di0" ]; then
    di0=$(cat /tmp/di0)
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/0/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di0_temp
    di0_temp=$(cat /tmp/di0_temp)
    if [ $di0_temp -eq $di0 ]; then
        echo $name" - DI1 OK"
    else
        echo $name" - DI1 ETAT CHANGE"
        json="{\"ID\":\"$name\",\"serial\":\"$serial\",\"DI1\":\"$di0_temp\"}"
        curl --max-time 3.0 --max-time 3.0 -X POST -H "Content-Type: application/json" \
        -d $json http://$SERVER_IP:$SERVER_PORT/parsing_moxa_event.php
        echo $di0_temp > /tmp/di0
    fi
    if [ -f "/root/reboot" ]; then
        di0=$(cat /root/last_state_di0)
        if [ $di0_temp -ne $di0 ]; then
            #/sbin/
            #gpio.sh invert DOUT2
            if [ $di0 == 0 ]; then
                ubus call ioman.relay.relay0 update '{"state":"closed"}'
            fi
            rm -rf /root/reboot
        fi
        echo $di0_temp > /root/last_state_di0
        rm -rf /root/reboot
    fi
    echo $di0_temp > /root/last_state_di0
else
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/0/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di0
    echo $di0_temp > /root/last_state_di0
fi

if [ -f "/tmp/di1" ]; then
    di1=$(cat /tmp/di1)
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/1/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di1_temp
    di1_temp=$(cat /tmp/di1_temp)
    if [ $di1_temp -eq $di1 ]; then
        echo $name" - DI2 OK"
    else
        echo $name" - DI2 ETAT CHANGE"
        json="{\"ID\":\"$name\",\"serial\":\"$serial\",\"DI2\":\"$di1_temp\"}"
        curl --max-time 3.0 -X POST -H "Content-Type: application/json" \
        -d $json http://$SERVER_IP:$SERVER_PORT/parsing_moxa_event.php
        echo $di1_temp > /tmp/di1
    fi
else
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/1/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di1
fi

if [ -f "/tmp/di2" ]; then
    di2=$(cat /tmp/di2)
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/2/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di2_temp
    di2_temp=$(cat /tmp/di2_temp)
    if [ $di2_temp -eq $di2 ]; then
        echo $name" - DI3 OK"
    else
        echo $name" - DI3 ETAT CHANGE"
        json="{\"ID\":\"$name\",\"serial\":\"$serial\",\"DI3\":\"$di2_temp\"}"
        curl --max-time 3.0 -X POST -H "Content-Type: application/json" \
        -d $json http://$SERVER_IP:$SERVER_PORT/parsing_moxa_event.php
        echo $di2_temp> /tmp/di2
    fi
else
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/2/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di2
fi

if [ -f "/tmp/di3" ]; then
    di3=$(cat /tmp/di3)
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/3/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di3_temp
    di3_temp=$(cat /tmp/di3_temp)
    if [ $di3_temp -eq $di3 ]; then
        echo $name" - DI4 OK"
    else
        echo $name" - DI4 ETAT CHANGE"
        json="{\"ID\":\"$name\",\"serial\":\"$serial\",\"DI4\":\"$di3_temp\"}"
        curl --max-time 3.0 -X POST -H "Content-Type: application/json" \
        -d $json http://$SERVER_IP:$SERVER_PORT/parsing_moxa_event.php
        echo $di3_temp> /tmp/di3
    fi
else
    curl --max-time 3.0 -s -H "Content-type: application/json" -H "Accept: vdn.dac.v1" \
    --request GET  http://$MOXA_IP/api/slot/0/io/di/3/diStatus \
    | cut -d"S" -f2 | cut -d":" -f2 | tr -d '\{\}' > /tmp/di3
fi
rm -rf /tmp/di*_temp
exit 0