# ICS
DEPOT POUR LES SCRIPTS DEPLOYES CHEZ LE CLIENT "ICS"

##### check_event_moxa.sh
- SCRIPT POUR LES RUT955
- VIENT EN APPUI AU SERVICE "MODBUS SENT TO SERVER" POUR PALIER CONTROLER LES EVENEMENTS ENTRE CHAQUE ENVOI PROGRAMME
- SCRIPT CONTORLE PAR UN AUTRE SCRIPT (loop_contro.sh) LANCE AU DEMARRAGE DU RUT955
- IO CIBLES SONT : DI0 / DI1 / DI2 / DI3

##### PARAMETRAGE RUT955
- JSON DATA TO SERVER
{"ST":"%r","VR":"%a","SN":"%n","SR":"TBZDB1028689"} # %ST -> request name, % VR -> request value,
- I/O CONFIG
-- DI-01 to DI-04 : 8bit Integer / Read inputs (2) / register 1 to 4 / count : 1
-- AI-01 to AI-04 : 16bit Integer Unsigned / Read input registers (4) / register 513 to 516 / count : 1

#### CRONTAB
* * * * * sh /root/check_event_moxa.sh /root/check_event_moxa.conf
* * * * * sleep 15 && sh /root/check_event_moxa.sh /root/check_event_moxa.conf
* * * * * sleep 30 && sh /root/check_event_moxa.sh /root/check_event_moxa.conf
* * * * * sleep 45 && sh /root/check_event_moxa.sh /root/check_event_moxa.conf
