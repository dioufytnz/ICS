#!/bin/bash

FILE1=/var/www/html/ics/BRAND_SERIAL
if test -f "$FILE1"; then
    echo "$FILE1 exists."
    timestamp_uptime_first=$(cat $FILE1)
    timestamp_uptime_now=$(date +"%s")
    uptime=$(($timestamp_uptime_now - $timestamp_uptime_first))
    result=$(curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary 'BRAND_SERIAL,nom=FORAGE_NAME UP='$uptime)
    echo $result >> /var/www/html/ics/test_cron.log
    echo "le fichier existe - ".$FILE1 >> /var/www/html/ics/test_cron.log
else
    echo "le fichier NOT existe" >> /var/www/html/ics/test_cron.log

fi
exit