#!/bin/sh
set -x
    # curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" \
    # --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" \
    # --data-urlencode "q=SELECT * FROM "wago_55732" WHERE ("nom" = 'S7') AND time >=now() - 8h" -H "Accept: application/csv" \
    # > /tmp/extraction8h.csv
    # file=\"/tmp/extraction8h.csv"
    # date=$(date +"%s"000000000)

    NOW=$(($(date +%s%N)/1000000)) ### date actuel en milliseconds 13 digits
    ##### 8heures en millisecondes
    POSTE_TIME=$((8 * 60 * 60 * 1000))
    POSTE1=$(($NOW - $POSTE_TIME))
    POSTE2=$(($POSTE1 - $POSTE_TIME))
    POSTE3=$(($POSTE2 - $POSTE_TIME))
    POSTE4=$(($POSTE3 - $POSTE_TIME))
    LAST_UP3=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    LAST_UP3=$(( $LAST_UP3 / 60 / 60 ))
    echo $LAST_UP3
    LAST_UP2=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE2"ms and time < "$POSTE1"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    LAST_UP2=$(( $LAST_UP2 / 60 / 60 ))
    echo $LAST_UP2
    LAST_UP1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE3"ms and time < "$POSTE2"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    LAST_UP1=$(( $LAST_UP1 / 60 / 60 ))
    echo $LAST_UP1
    MEAN_AI1_3=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    MEAN_AI1_3=$(echo "scale=2;$MEAN_AI1_3/1" | bc)
    echo $MEAN_AI1_3
    MEAN_AI1_2=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE2"ms and time < "$POSTE1"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    MEAN_AI1_2=$(echo "scale=2;$MEAN_AI1_2/1" | bc)
    echo $MEAN_AI1_2
    MEAN_AI1_1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE3"ms and time < "$POSTE2"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    MEAN_AI1_1=$(echo "scale=2;$MEAN_AI1_1/1" | bc)
    echo $MEAN_AI1_1

    TODAY=$(date +"%Y%m%d")
    YESTERDAY=$(date +"%d/%m/%Y" --date="1 day ago")
    DAY=$(date +"%d")
    MONTH=$(date +"%m")
    YEAR=$(date +"%Y")
    HEURE=$(date +"%H : %M")
    #######@
    echo "<html>\n<body>\n" > rapport_$TODAY.html
    echo "<center><img src=\"/var/www/html/ics/ics-indorama.png\" alt=\"LOGO\" width=\"200\" height=\"130\"/></center>\n" >> rapport_$TODAY.html
    echo "<center><h1>RAPPORT JOURNALIER SUR DES FORAGES</h1></center>\n" >> rapport_$TODAY.html
    echo "<center><h2>DATE : $DAY - $MONTH - $YEAR <> $HEURE</h2></center>\n" >> rapport_$TODAY.html
    echo "<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\n<tbody>\n<tr>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>FORAGE</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>POSTES</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>HORAMETRE</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>HM</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>COMPTEUR VOL.</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>VOLUME</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 10%; background-color:#0099cc; padding:7px\"><b>COMPTEUR DEBIT</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>MOYENNE INTENSITE</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>MOYENNE PRESSION</b></td>\n" >> rapport_$TODAY.html
    echo "<td style=\"width: 34%; background-color:#0099cc; padding:7px\"><b>COMMENTAIRES</b></td>\n" >> rapport_$TODAY.html
    echo "</tr>\n" >> rapport_$TODAY.html
    echo "FORAGE;POSTES;HORAMETRE;HM;COMPTEUR VOL.;VOLUME;COMPTEUR DEBIT;MOYENNE INTENSITE;MOYENNE PRESSION;COMMENTAIRES\n" > /var/ftp/pub/rapport_excel_$TODAY.csv
    ########
    file="/var/www/html/ics/liste_forages.txt"
    while IFS= read -r line
    do
        SERIE=$(echo "$line" | cut -d";" -f1)
        NAME=$(echo "$line" | cut -d";" -f2)
        ###
        LAST_UP3=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        if [ -z "$LAST_UP3" ]; then
            LAST_UP3=0
        else
            LAST_UP3=$(( $LAST_UP3 / 60 / 60 ))
        fi
        ###
        LAST_UP2=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= "$POSTE2"ms and time < "$POSTE1"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        if [ -z "$LAST_UP2" ]; then
            LAST_UP2=0
        else
            LAST_UP2=$(( $LAST_UP2 / 60 / 60 ))
        fi
        ###
        LAST_UP1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= "$POSTE3"ms and time < "$POSTE2"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        if [ -z "$LAST_UP1" ]; then
            LAST_UP1=0
        else
            LAST_UP1=$(( $LAST_UP1 / 60 / 60 ))
        fi
        ###
        LAST_UP0=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= "$POSTE4"ms and time < "$POSTE3"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        if [ -z "$LAST_UP0" ]; then
            LAST_UP0=0
        else
            LAST_UP0=$(( $LAST_UP0 / 60 / 60 ))
        fi
        ###
##################
        ###
        if [ $LAST_UP1 = 0 ]; then
            HM1=0
        else
            HM1=$(( $LAST_UP1 - $LAST_UP0 ))
        fi


        if [ $LAST_UP2 = 0 ]; then
            HM2=0
        else
            HM2=$(( $LAST_UP2 - $LAST_UP1 ))
        fi

        if [ $LAST_UP3 = 0 ]; then
            HM3=0
        else
            HM3=$(( $LAST_UP3 - $LAST_UP2 ))
        fi



        TOTAL=$(( $HM1 + $HM2 + $HM3 ))

        MEAN_AI1_3=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "$SERIE" WHERE ("nom" = '$NAME')
AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        MEAN_AI1_3=$(echo "scale=2;$MEAN_AI1_3/1" | bc)
        MEAN_AI1_2=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "$SERIE" WHERE ("nom" = '$NAME')
AND time >= "$POSTE2"ms and time < "$POSTE1"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        MEAN_AI1_2=$(echo "scale=2;$MEAN_AI1_2/1" | bc)
        MEAN_AI1_1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "$SERIE" WHERE ("nom" = '$NAME')
AND time >= "$POSTE3"ms and time < "$POSTE2"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        MEAN_AI1_1=$(echo "scale=2;$MEAN_AI1_1/1" | bc)
        ######
        echo "<tr>\n<td style=\"width: 7%;\" rowspan=\"4\"><b>$NAME</b></td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\"><b>POSTE 1</b><br><h1 style=\"font-size:70%;\">$YESTERDAY</h1><h1 style=\"font-size:70%;\">06H - 14H</h1></td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$LAST_UP1</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$HM1</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 10%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$MEAN_AI1_1</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 34%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "</tr>" >> rapport_$TODAY.html
        echo $NAME";POSTE 1***"$YESTERDAY";"$LAST_UP1";"$HM1";N\A;N\A;N\A;"$MEAN_AI1_1";N\A;\n" >> /var/ftp/pub/rapport_excel_$TODAY.csv
        ####
        ######
        echo "<tr>\n<td style=\"width: 7%; padding:5px\"><b>POSTE 2</b><br><h1 style=\"font-size:70%;\">$YESTERDAY</h1><h1 style=\"font-size:70%;\">14H - 22H</h1></td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$LAST_UP2</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$HM2</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 10%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$MEAN_AI1_2</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 34%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "</tr>" >> rapport_$TODAY.html
        echo $NAME";POSTE 2***"$YESTERDAY";"$LAST_UP2";"$HM2";N\A;N\A;N\A;"$MEAN_AI1_2";N\A;\n" >> /var/ftp/pub/rapport_excel_$TODAY.csv
        ####
        ######
        echo "<tr>\n<td style=\"width: 7%; padding:5px\"><b>POSTE 3</b><br><h1 style=\"font-size:70%;\">$YESTERDAY</h1><h1 style=\"font-size:70%;\">22HH - 06H</h1>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$LAST_UP3</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$HM3</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 10%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$MEAN_AI1_3</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 34%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "</tr>" >> rapport_$TODAY.html
        echo $NAME";POSTE 3***"$YESTERDAY";"$LAST_UP3";"$HM3";N\A;N\A;N\A;"$MEAN_AI1_3";N\A;\n" >> /var/ftp/pub/rapport_excel_$TODAY.csv
        ####
        ######
        echo "<tr>\n<td style=\"width: 7%;\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%;  padding:5px\"><b>TOTAL</b></td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">$TOTAL</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 10%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 7%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "<td style=\"width: 34%; padding:5px\">&nbsp;</td>" >> rapport_$TODAY.html
        echo "</tr>\n" >> rapport_$TODAY.html
        echo ";;TOTAL;$TOTAL;;;;;;\n" >> /var/ftp/pub/rapport_excel_$TODAY.csv
        ####
    done < "$file"

    echo "</tbody>\n" >> rapport_$TODAY.html
    echo "</table>\n" >> rapport_$TODAY.html
    echo "<body>\n<html>" >> rapport_$TODAY.html
    echo "Bonjour,\n\n" > email.txt
    echo "Merci de trouver joint le rapport du jour sur la situation des forages\n\n" >> email.txt
    echo "******** P.S : Ceci est un email automatique. Merci de ne pas y répondre ********" >> email.txt

    xvfb-run wkhtmltopdf -s A4 --orientation Landscape rapport_$TODAY.html /var/ftp/pub/rapport_$TODAY.pdf

    cp /var/ftp/pub/rapport_$TODAY.pdf /var/www/html/ics/rapports/
    cp /var/ftp/pub/rapport_excel_$TODAY.csv  /var/www/html/ics/rapports/
    ##$rapport="/var/www/html/ics/rapport_"$TODAY".pdf"
    ##curl --url 'smtp://mail33.lwspanel.com:587' --mail-from 'contact@tenezis.pro' --mail-rcpt 'mamadou.diouf@tenezis.pro'  -H "Subject: RAPPORT FORAGE DU $TODAY" -F attachment=@$rapport -T email.txt --user 'mamadou.diouf@tenezis.pro:Acces@mamadou1'

set +x