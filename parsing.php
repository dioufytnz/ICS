<?php

/////////////////////////////////////////////////////
// PARSAGE DES DONNEES RECUS DEPUIS LES APPAREILS WAGO
/////////////////////////////////////////////////////

////////////// INITIALISATION ENREGISTEMENTS////////

$date = date('Y-m-d H:i:s');
$entete = "//////////////".$date." //////////////\n";
file_put_contents('datas.log', $entete, FILE_APPEND);

////////////// EXTRACTION DES DONNEES ENTETE ///////////////

$remote_ip = $_SERVER["REMOTE_ADDR"] ?? '127.0.0.1';

foreach (getallheaders() as $name => $value) {
    file_put_contents('datas.log', "FROM \"getallheaders\" :".$name." => ".$value."\n", FILE_APPEND);
    //echo "$name: $value\n";
}


foreach ($_POST as $key => $value) {
    $type_value = gettype($value);
    file_put_contents('datas.log', "HEADER > ".$key." => ".$value." :::  TYPE : ".$type_value."\n", FILE_APPEND);
}
//////////////////////////////////////////////////////

////////////// EXPLODE DES DONNEES///////////////

file_put_contents('datas.log', "REMOTE IP > ".$remote_ip."\n", FILE_APPEND);

$timestamp_uptime = time();

$AI1 = explode(";", $_POST["A1"]);
$AI1 = str_replace(' ', '', $AI1);
$AI2 = explode(";", $_POST["A2"]);
$AI2 = str_replace(' ', '', $AI2);
//$DO = str_split($_POST["DO"]);
$ID = explode(";", $_POST["ID"]);
$PA = explode(";", $_POST["PA"]);
$TI = explode(",", $_POST["TI"]);
$DI1 = explode(";", $_POST["D1"]);
$DI2 = explode(";", $_POST["D2"]);
$DI3 = explode(";", $_POST["D3"]);
//$VS = explode(";", $_POST["VS"]);
//$VS = str_replace(' ', '', $VS);

$file_pointer = "wago_".$ID[1];
$file_pointer_old = "wago_".$ID[1]."_old";
//
$file_pointer2 = "wago_".$ID[1]."_2";
$file_pointer_old2 = "wago_".$ID[1]."_old_2";

if (($DI1[0] == "1" || $DI1[0] == 1) && ($DI1[1] == "1" || $DI1[1] == 1)) //ETAT ALARME "DI" LORS DE L'ACTIVATION DU "DOUT"
{
    $DI1_STAT="MARCHE";
    if (file_exists($file_pointer)) { // VERIFICATION FICHIER INITIALISATION DEMARRAGE - PREFIXE PAR LE NUMERO DE SERIE
        //echo "Le fichier $filename existe.";
        file_put_contents('datas.log', "Moteur toujours en marche \n", FILE_APPEND);
    } else {
        if (file_exists($file_pointer_old))
            {
                file_put_contents('datas.log', "*************** MOTEUR REDEMARRE à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
                $last_duration = file_get_contents($file_pointer_old);
                $new_uptime = $timestamp_uptime - $last_duration;
                file_put_contents($file_pointer_old, $new_uptime);
                rename($file_pointer_old, $file_pointer);
            }
        else {

                file_put_contents('wago_'.$ID[1], $timestamp_uptime); //INITIALISATION DE L'HEURE DEBUT DE MARCHE
                file_put_contents('datas.log', "Moteur démarré à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
            }
    }
}

if (($DI3[0] == "1" || $DI3[0] == 1) && ($DI3[1] == "1" || $DI3[1] == 1) && ($ID[0] == "Exhaure3")) //ETAT ALARME "DI" LORS DE L'ACTIVATION DU "DOUT"
{
    $DI3_STAT="MARCHE";
    if (file_exists($file_pointer2)) { // VERIFICATION FICHIER INITIALISATION DEMARRAGE - PREFIXE PAR LE NUMERO DE SERIE
        //echo "Le fichier $filename existe.";
        file_put_contents('datas.log', "Moteur 2 toujours en marche \n", FILE_APPEND);
    } else {
        if (file_exists($file_pointer_old2))
            {
                file_put_contents('datas.log', "*************** MOTEUR 2 REDEMARRE à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 DEMARRE\n", FILE_APPEND);
                $last_duration = file_get_contents($file_pointer_old2);
                $new_uptime = $timestamp_uptime - $last_duration;
                file_put_contents($file_pointer_old2, $new_uptime);
                rename($file_pointer_old2, $file_pointer2);
            }
        else {

                file_put_contents('wago_'.$ID[1].'_2', $timestamp_uptime); //INITIALISATION DE L'HEURE DEBUT DE MARCHE
                file_put_contents('datas.log', "Moteur 2 démarré à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 DEMARRE\n", FILE_APPEND);
            }
    }
}


if (($DI1[0] == "0" || $DI1[0] == 0) && ($DI1[1] == "1" || $DI1[1] == 1)) // ETAT ALARME AVEC "DI" DESACTIVEPOUR ARRET
{
    $DI1_STAT="ARRET";
    if (file_exists($file_pointer))
            {
                $last_uptime = file_get_contents($file_pointer);
                $last_duration = $timestamp_uptime - $last_uptime;
                file_put_contents($file_pointer, $last_duration);
                rename($file_pointer, $file_pointer_old);
                file_put_contents('datas.log', "Moteur arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR ARRETE\n", FILE_APPEND);
            }
        else {
                file_put_contents('datas.log', "Moteur arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR ARRETE\n", FILE_APPEND);
            }
}

if (($DI3[0] == "0" || $DI3[0] == 0) && ($DI3[1] == "1" || $DI3[1] == 1) && ($ID[0] == "Exhaure3")) // ETAT ALARME AVEC "DI" DESACTIVEPOUR ARRET
{
    $DI3_STAT="ARRET";
    if (file_exists($file_pointer2))
            {
                $last_uptime = file_get_contents($file_pointer);
                $last_duration = $timestamp_uptime - $last_uptime;
                file_put_contents($file_pointer2, $last_duration);
                rename($file_pointer2, $file_pointer_old2);
                file_put_contents('datas.log', "Moteur 2 arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 ARRETE\n", FILE_APPEND);
            }
        else {
                file_put_contents('datas.log', "Moteur 2 arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 ARRETE\n", FILE_APPEND);
            }
}

if (($DI1[0] == "1" || $DI1[0] == 1) && ($DI1[1] == "0" || $DI1[1] == 0)) //ETAT TOUJOURS EN MARCHE
{
    $DI1_STAT="MARCHE";
    if (file_exists($file_pointer)) { // VERIFICATION FICHIER INITIALISATION DEMARRAGE - PREFIXE PAR LE NUMERO DE SERIE
        //echo "Le fichier $filename existe.";
        file_put_contents('datas.log', "Moteur toujours en marche \n", FILE_APPEND);
    } else {
        if (file_exists($file_pointer_old))
            {
                file_put_contents('datas.log', "*************** MOTEUR REDEMARRE à ".$date."\n", FILE_APPEND);
                $last_duration = file_get_contents($file_pointer_old);
                $new_uptime = $timestamp_uptime - $last_duration;
                file_put_contents($file_pointer_old, $new_uptime);
                rename($file_pointer_old, $file_pointer);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
            }
        else {

                file_put_contents('wago_'.$ID[1], $timestamp_uptime); //INITIALISATION DE L'HEURE DEBUT DE MARCHE
                file_put_contents('datas.log', "Moteur démarré à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
            }
    }

}

if (($DI3[0] == "1" || $DI3[0] == 1) && ($DI3[1] == "0" || $DI3[1] == 0) && ($ID[0] == "Exhaure3")) //ETAT TOUJOURS EN MARCHE
{
    $DI3_STAT="MARCHE";
    if (file_exists($file_pointer2)) { // VERIFICATION FICHIER INITIALISATION DEMARRAGE - PREFIXE PAR LE NUMERO DE SERIE
        //echo "Le fichier $filename existe.";
        file_put_contents('datas.log', "Moteur 2 toujours en marche \n", FILE_APPEND);
    } else {
        if (file_exists($file_pointer_old2))
            {
                file_put_contents('datas.log', "*************** MOTEUR 2 REDEMARRE à ".$date."\n", FILE_APPEND);
                $last_duration = file_get_contents($file_pointer_old2);
                $new_uptime = $timestamp_uptime - $last_duration;
                file_put_contents($file_pointer_old2, $new_uptime);
                rename($file_pointer_old2, $file_pointer2);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 DEMARRE\n", FILE_APPEND);
            }
        else {

                file_put_contents('wago_'.$ID[1].'_2', $timestamp_uptime); //INITIALISATION DE L'HEURE DEBUT DE MARCHE
                file_put_contents('datas.log', "Moteur 2 démarré à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 DEMARRE\n", FILE_APPEND);
            }
    }
}

if (($DI1[0] == "0" || $DI1[0] == 0) && ($DI1[1] == "0" || $DI1[1] == 0)) // MOTEUR EN ARRET
{
    if (file_exists($file_pointer))
            {
                $last_uptime = file_get_contents($file_pointer);
                $last_duration = $timestamp_uptime - $last_uptime;
                file_put_contents($file_pointer, $last_duration);
                rename($file_pointer, $file_pointer_old);
            }
    $DI1_STAT="ARRET";
}

if (($DI3[0] == "0" || $DI3[0] == 0) && ($DI3[1] == "0" || $DI3[1] == 0) && ($ID[0] == "Exhaure3")) // MOTEUR EN ARRET
{
    if (file_exists($file_pointer2))
            {
                $last_uptime = file_get_contents($file_pointer2);
                $last_duration = $timestamp_uptime - $last_uptime;
                file_put_contents($file_pointer2, $last_duration);
                rename($file_pointer2, $file_pointer_old2);
            }
    $DI3_STAT="ARRET";
}


if ($DI2[1] == "1" || $DI2[1] == 1)
{
    $DI2_STAT="DEFAUT";
    file_put_contents('datas.log', "*************** Moteur EN DEFAUT\n", FILE_APPEND);
    file_put_contents('notes.log', $ID[0]." ".$date." MOTEUR EN DEFAUT\n", FILE_APPEND);
}
else
{
    $DI2_STAT="OK";
    file_put_contents('datas.log', "Pas de défaut\n", FILE_APPEND);
}

if (($DI3[1] == "1" || $DI3[1] == 1) && ($ID[0] != "Exhaure3"))
{
    $DI3_STAT="DEFAUT";
    file_put_contents('datas.log', "*************** DEFAUT TENSION\n", FILE_APPEND);
    file_put_contents('notes.log', $ID[0]." ".$date." DEFAUT TENSION\n", FILE_APPEND);
}

if (($DI3[1] == "0" || $DI3[1] == 0) && ($ID[0] != "Exhaure3"))
{
    $DI3_STAT="OK";
    file_put_contents('datas.log', "Pas de défaut tension\n", FILE_APPEND);
}

$DI4 = explode(";", $_POST["D4"]);
if (($DI4[1] == "1" || $DI4[1] == 1) && ($ID[0] == "Exhaure3"))
{
    $DI4_STAT="DEFAUT";
    file_put_contents('datas.log', "*************** Moteur 2 EN DEFAUT\n", FILE_APPEND);
    file_put_contents('notes.log', $ID[0]."_2 ".$date." MOTEUR 2 EN DEFAUT\n", FILE_APPEND);
}
else
{
    $DI4_STAT="OK";
    file_put_contents('datas.log', "Pas de défaut sur la 2\n", FILE_APPEND);
}

///////////// GESTION DE LA CONSERVATION DES ETATS /////////////////

$TI_YEAR = explode("/", $TI[0]);
file_put_contents('datas.log', "ANNEE SYNC = ".$TI_YEAR[0]."\n", FILE_APPEND);
if ($TI_YEAR >= 1)
{
    file_put_contents('datas.log', "DATE OK\n", FILE_APPEND);
}
else
{
    file_put_contents('datas.log', "ATTENTION COUPURE DE COURANT DETECTE\n", FILE_APPEND);
    $load3 = "q=SELECT last(\"DI1S\") FROM \"wago_".$ID[1]."\" WHERE (\"nom\" = '".$ID[0]."') AND time >= now() - 3h";
    $load4 = "q=SELECT last(\"DI3S\") FROM \"wago_".$ID[1]."_2\" WHERE (\"nom\" = '".$ID[0]."_2') AND time >= now() - 3h";
    $shell_command1 = "cat listeNumeroMobile.txt | grep \"".$ID[0]."\" | rev | cut -d\";\" -f1 | rev";
    $shell_command2 = "cat listeNumeroMobile.txt | grep \"".$ID[0]."_2\" | rev | cut -d\";\" -f1 | rev";
    if ($ID[0] == "Exhaure3")
    {
         $response4 = shell_exec("curl -G 'http://localhost:8086/query?pretty=false' --data-urlencode \"db=metrics_ics\" --data-urlencode \"$load4\"");
         $response3 = shell_exec("curl -G 'http://localhost:8086/query?pretty=false' --data-urlencode \"db=metrics_ics\" --data-urlencode \"$load3\"");
         if (strpos($response4, 'MARCHE') == true) {
             file_put_contents('datas.log', "DERNIER ETAT 2 : MARCHE\n", FILE_APPEND);
             $number = shell_exec("cat $shell_command2");
             //$response5 = shell_exec("curl http://192.168.23.137/cgi-bin/sms_send?username=sms&password=sms&number=$number&text=DOUT(1)=1");
             file_put_contents('notes.log', $ID[0]."_2 ".$date." TENTATIVE DEMARRAGE MOTEUR 2 APRES COUPURE\n", FILE_APPEND);
         }
         else
         {
             file_put_contents('datas.log', "DERNIER ETAT 2 : ARRET\n", FILE_APPEND);
         }
         if (strpos($response3, 'MARCHE') == true) {
             file_put_contents('datas.log', "DERNIER ETAT 1 : MARCHE\n", FILE_APPEND);
             $number = shell_exec("cat $shell_command1");
             //$response5 = shell_exec("curl http://192.168.23.137/cgi-bin/sms_send?username=sms&password=sms&number=$number&text=DOUT(1)=1");
             file_put_contents('notes.log', $ID[0]." ".$date." TENTATIVE DEMARRAGE MOTEUR 1 APRES COUPURE\n", FILE_APPEND);
         }
         else
         {
             file_put_contents('datas.log', "DERNIER ETAT 1 : ARRET\n", FILE_APPEND);
         }
     }
    else
    {
       $response3 = shell_exec("curl -G 'http://localhost:8086/query?pretty=false' --data-urlencode \"db=metrics_ics\" --data-urlencode \"$load3\"");
       if (strpos($response3, 'MARCHE') == true) {
          file_put_contents('datas.log', "DERNIER ETAT : MARCHE\n", FILE_APPEND);
          $number = shell_exec("cat $shell_command1");
          //$response5 = shell_exec("curl http://192.168.23.137/cgi-bin/sms_send?username=sms&password=sms&number=$number&text=DOUT(1)=1");
          file_put_contents('notes.log', $ID[0]." ".$date." TENTATIVE DEMARRAGE MOTEUR APRES COUPURE\n", FILE_APPEND);
       }
       else
       {
          file_put_contents('datas.log', "DERNIER ETAT : ARRET\n", FILE_APPEND);
       }
    }

}


///////////////// REPONSE A LA REQUETE ////////////////////////////////////
$date1 = date_create();
echo "Values stored:".date_format($date1, 'y/m/d,H:i:s'); //REPONSE RENVOYEE
$stored=date_format($date1, 'y/m/d,H:i:s');
file_put_contents('datas.log', "Values stored:".$stored."\n", FILE_APPEND);
//////////////////////////////////////////////////////////////////////////////

$t=microtime(true);
$ts = explode(".", $t);
$tt = $ts[0].$ts[1];
file_put_contents('datas.log', "TIMESTAMP EN MS : ".$tt."\n", FILE_APPEND);




if (($ID[0] == "Exhaure3"))
{
    $load = "wago_".$ID[1]."_2,nom=".$ID[0]."_2 AI1=".$AI1[0].",DI1=".$DI1[0].",DI2=".$DI2[0].",DI1S=\"".$DI1_STAT."\",DI2S=\"".$DI2_STAT."\",PA=".$PA[0].",name=\"".$ID[0]."_2\",AI2=".$AI2[0].",DI3S=\"".$DI3_STAT."\",DI4S=\"".$DI4_STAT."\"";
    $load1 = "wago_".$ID[1].",nom=".$ID[0]." AI1=".$AI1[0].",DI1=".$DI1[0].",DI2=".$DI2[0].",DI1S=\"".$DI1_STAT."\",DI2S=\"".$DI2_STAT."\",PA=".$PA[0].",name=\"".$ID[0]."\"";
    $response1 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load'");
    $response2 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load1'");
    file_put_contents('datas.log', "REPONSE POST SUR INNFLUXDB => ".$response1."\n", FILE_APPEND);
    file_put_contents('datas.log', "REPONSE POST SUR INNFLUXDB => ".$response2."\n", FILE_APPEND);
}
else
{
    $load = "wago_".$ID[1].",nom=".$ID[0]." AI1=".$AI1[0].",DI1=".$DI1[0].",DI2=".$DI2[0].",DI1S=\"".$DI1_STAT."\",DI2S=\"".$DI2_STAT."\",DI3S=\"".$DI3_STAT."\",PA=".$PA[0].",name=\"".$ID[0]."\",AI2=".$AI2[0];
    $response1 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load'");
}


?>
