#!/bin/sh
i=1
while [ "$i" -ne 0 ]
do
  sh /root/check_event_moxa.sh /root/check_event_moxa.conf
  i=1
  sleep 10
done
exit 0