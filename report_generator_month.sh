#!/bin/sh
set -x
    # curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" \
    # --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" \
    # --data-urlencode "q=SELECT * FROM "wago_55732" WHERE ("nom" = 'S7') AND time >=now() - 8h" -H "Accept: application/csv" \
    # > /tmp/extraction8h.csv
    # file=\"/tmp/extraction8h.csv"
    # date=$(date +"%s"000000000)


    #0 FIRST THINGS

    NOW=$(($(date +%s%N)/1000000)) ### date actuel en milliseconds 13 digits

    #1 DETECT FIRST DAY OF THE MONTH BY CRONTAB
    #2 DETECT NUMBER OF DAY IN LAST MONTH

    NBR_DAY_LAST_MONTH=$(cal $(date +"%m %Y" --date="1 day ago") | awk 'NF {DAYS = $NF}; END {print DAYS}')

    #3 TIME OF THE MONTH EN MS

    MONTH_TIME=$(( $NBR_DAY_LAST_MONTH * 24 * 60 * 60 * 1000))

    HM=$(( $NBR_DAY_LAST_MONTH * 24 ))

    #4

    LAST_UP=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    LAST_UP=$(( $LAST_UP / 60 / 60 ))
    echo $LAST_UP

    POSTE1=$(($NOW - $POSTE_TIME))
    # POSTE2=$(($POSTE1 - $POSTE_TIME))
    # POSTE3=$(($POSTE2 - $POSTE_TIME))
    # POSTE4=$(($POSTE3 - $POSTE_TIME))
    # LAST_UP=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= now() - 7h59m" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    # LAST_UP=$(( $LAST_UP / 60 / 60 ))
    # echo $LAST_UP
    # # LAST_UP2=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE2"ms and time < "$POSTE1"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    # # LAST_UP2=$(( $LAST_UP2 / 60 / 60 ))
    # # echo $LAST_UP2
    # # LAST_UP1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "wago_55732" WHERE ("nom" = 'S7') AND time >= "$POSTE3"ms and time < "$POSTE2"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
    # # LAST_UP1=$(( $LAST_UP1 / 60 / 60 ))
    #echo $LAST_UP1

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
    DAY=$(date +"%d")
    MONTH=$(date +"%m")
    YEAR=$(date +"%Y")
    HEURE=$(date +"%H : %M")
    #######@
    echo "<html>\n<body>\n" > rapport_mensuel_$MONTH_$YEAR.html
    echo "<center><img src=\"ics-indorama.png\" alt=\"LOGO\" width=\"200\" height=\"130\"/></center>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<center><h1>RAPPORT MENSUEL SUR DES FORAGES</h1></center>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<center><h2>DATE : $DAY - $MONTH - $YEAR <> $HEURE</h2></center>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<table style=\"border-collapse: collapse; width: 100%;\" border=\"1\">\n<tbody>\n<tr>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>FORAGE</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    #echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>POSTES</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>HORAMETRE</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>HM</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>COMPTEUR VOL.</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>VOLUME</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 10%; background-color:#0099cc; padding:7px\"><b>COMPTEUR DEBIT</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>MOYENNE INTENSITE</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 7%; background-color:#0099cc; padding:7px\"><b>MOYENNE PRESSION</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<td style=\"width: 34%; background-color:#0099cc; padding:7px\"><b>COMMENTAIRES</b></td>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "</tr>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "FORAGE;HORAMETRE;HM;COMPTEUR VOL.;VOLUME;COMPTEUR DEBIT;MOYENNE INTENSITE;MOYENNE PRESSION;COMMENTAIRES\n" > rapport_excel_mensuel_$MONTH_$YEAR.csv
    ########
    file="/var/www/html/ics/liste_forages.txt"
    while IFS= read -r line
    do
        SERIE=$(echo "$line" | cut -d";" -f1)
        NAME=$(echo "$line" | cut -d";" -f2)
        ###
        LAST_UP=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT last("UP") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= now() - "$MONTH_TIME"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        if [ -z "$LAST_UP" ]; then
            LAST_UP=0
        else
            LAST_UP=$(( $LAST_UP / 60 / 60 ))
        fi

        MEAN_AI1=$(curl -G 'http://localhost:8086/query' --data-urlencode "db=metrics_ics" --data-urlencode "chunked=true" --data-urlencode "chunk_size=20000" --data-urlencode "q=SELECT mean("AI1") FROM "$SERIE" WHERE ("nom" = '$NAME') AND time >= now() - "$MONTH_TIME"ms" -H "Accept: application/csv" 2>/dev/null | awk '{if(NR>1)print}' | rev | cut -d"," -f1 | rev)
        MEAN_AI1=$(echo "scale=2;$MEAN_AI1/1" | bc)


        ###### COMPOSITION DU FICHIER
        echo "<tr>\n<td style=\"width: 7%;\"><b>$NAME</b></td>" >> rapport_mensuel_$MONTH_$YEAR.html
        #echo "<td style=\"width: 7%; padding:5px\"><b>POSTE 1</b><br><h1 style=\"font-size:70%;\">$YESTERDAY</h1><h1 style=\"font-size:70%;\">06H - 14H</h1></td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">$LAST_UP</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">$HM</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 10%; padding:5px\">N\A</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">$MEAN_AI_1</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 7%; padding:5px\">N\A</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "<td style=\"width: 34%; padding:5px\">&nbsp;</td>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo "</tr>" >> rapport_mensuel_$MONTH_$YEAR.html
        echo $NAME";"$LAST_UP";"$HM";N\A;N\A;N\A;"$MEAN_AI1_1";N\A;\n" >> rapport_excel_mensuel_$MONTH_$YEAR.csv


    done < "$file"

    echo "</tbody>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "</table>\n" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "<body>\n<html>" >> rapport_mensuel_$MONTH_$YEAR.html
    echo "Bonjour,\n\n" > email.txt
    echo "Merci de trouver joint le rapport du jour sur la situation des forages\n\n" >> email.txt
    echo "******** P.S : Ceci est un email automatique. Merci de ne pas y répondre ********" >> email.txt

    xvfb-run wkhtmltopdf -s A4 --orientation Landscape rapport_mensuel_$MONTH_$YEAR.html /var/ftp/pub/rapport_$TODAY.pdf

    ##$rapport="/var/www/html/ics/rapport_"$TODAY".pdf"
    ##curl --url 'smtp://mail33.lwspanel.com:587' --mail-from 'contact@tenezis.pro' --mail-rcpt 'mamadou.diouf@tenezis.pro'  -H "Subject: RAPPORT FORAGE DU $TODAY" -F attachment=@$rapport -T email.txt --user 'mamadou.diouf@tenezis.pro:Acces@mamadou1'

set +x