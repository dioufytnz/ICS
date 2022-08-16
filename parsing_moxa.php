<?php

$remote_ip = $_SERVER["REMOTE_ADDR"] ?? '127.0.0.1';
$date = date('Y-m-d H:i:s');
foreach (getallheaders() as $name => $value) {
    file_put_contents('datas_moxa.log', $name." => ".$value."\n", FILE_APPEND);
    echo "$name: $value\n";
}


foreach ($_POST as $key => $value) {

        file_put_contents('datas_moxa.log', "HEADER > ".$key." => ".$value."\n", FILE_APPEND);

    }

file_put_contents('datas_moxa.log', $remote_ip." => ".$date."\n", FILE_APPEND);

$entityBody = file_get_contents('php://input');

file_put_contents('datas_moxa.log', $entityBody."\n", FILE_APPEND);

$table = json_decode($entityBody);

//file_put_contents('datas_moxa.log', $table[0]->IP . ", " . $table[0]->ST . ", ".  $table[0]->VR[0] ."\n", FILE_APPEND);
//ID : nom forage
$ID = $table[0]->SN;
$MAX_AI_SCALED_01 = $table[0]->MAX_AI_01;
//SR : serial moxa
$SR = $table[0]->SR;
//DI-01
$DI1 = $table[0]->VR[0];
//DI-02
$DI2 = $table[1]->VR[0];
//DI-03
$DI3 = $table[2]->VR[0];
//DI-04
$DI4 = $table[3]->VR[0];
//AI-00
$AI1 = $table[4]->VR[0];
//AI-01
$AI2 = $table[5]->VR[0];
//AI-02
$AI3 = $table[6]->VR[0];
//AI-03
$AI4 = $table[7]->VR[0];

$file_pointer = "moxa_".$SR;
$file_pointer_old = "moxa_".$SR."_old";
$timestamp_uptime = time();

///////////////// CONVERSION DES DONNEES ANNALOGIQUES //////////////////////
$DIVIDENDE = pow(2, 15);

file_put_contents('datas_moxa.log', "DIVIDENDE => ".$DIVIDENDE."\n", FILE_APPEND);
$MAX_RANGE_TENSION_10V = 10;
$MAX_RANGE_COURANT_4_20 = 16;
$MAX_AI_SCALED_01
//FFFE -> 65534
//3333 -> 13107
if ($AI1 > 13107)
{
    $AI1 = $AI1 * $MAX_AI_SCALED_01 / 65534
    $AI1 = number_format($AI1,1);
}else{
    $AI1 = 0;
}
if ($AI2 > 13107)
{
    $AI2 = $AI2 * $MAX_AI_SCALED_02 / 65534
    $AI2 = number_format($AI2,1);
}else{
    $AI2 = 0;
}
if ($AI3 > 13107)
{
    $AI3 = $AI3 * $MAX_AI_SCALED_03 / 65534
    $AI3 = number_format($AI3,1);
}else{
    $AI3 = 0;
}
if ($AI4 > 13107)
{
    $AI4 = $AI4 * $MAX_AI_SCALED_04 / 65534
    $AI4 = number_format($AI4,1);
}else{
    $AI4 = 0;
}


// if ($AI1 < 32768 || $AI2 < 32768 || $AI3 < 32768)
// {
//     $AI1 = $AI1 * ((($MAX_RANGE_COURANT_4_20 / 2) - 4)  / $DIVIDENDE);
//     $AI1 = number_format($AI1,1);
//     file_put_contents('datas_moxa.log', "AI1 => ".$AI1."\n", FILE_APPEND);
//     if ($AI1 < 0)
//     {
//         $AI1 = 0;
//     }
//     $AI2 = $AI2 * ((($MAX_RANGE_COURANT_4_20 / 2) - 4)  / $DIVIDENDE);
//     $AI2 = number_format($AI2,1);
//     if ($AI2 < 0)
//     {
//         $AI2 = 0;
//     }
//     $AI3 = $AI3 * ((($MAX_RANGE_COURANT_4_20 / 2) - 4) / $DIVIDENDE);
//     $AI3 = number_format($AI3,1);
//     if ($AI3 < 0)
//     {
//         $AI3 = 0;
//     }
//     $AI4 = $AI4 * $MAX_RANGE_TENSION_10V / $DIVIDENDE;
//     $AI4 = number_format($AI4,1);
//     if ($AI4 < 0)
//     {
//         $AI4 = 0;
//     }
// } else {

//     $AI1 = $AI1 * ($MAX_RANGE_COURANT_4_20 / $DIVIDENDE) - ($MAX_RANGE_COURANT_4_20 - 1);
//     $AI1 = number_format($AI1,2);
//     if ($AI1 < 0)
//     {
//         $AI1 = 0;
//     }
//     $AI2 = $AI2 * ($MAX_RANGE_COURANT_4_20 / $DIVIDENDE) - ($MAX_RANGE_COURANT_4_20 - 1);
//     $AI2 = number_format($AI2,2);
//     if ($AI2 < 0)
//     {
//         $AI2 = 0;
//     }
//     $AI3 = $AI3 * ($MAX_RANGE_COURANT_4_20 / $DIVIDENDE) - ($MAX_RANGE_COURANT_4_20 - 1);
//     $AI3 = number_format($AI3,2);
//     if ($AI3 < 0)
//     {
//         $AI3 = 0;
//     }
//     $AI4 = $AI4 * $MAX_RANGE_TENSION_10V / $DIVIDENDE;
//     $AI4 = number_format($AI4,2);
//     if ($AI4 < 0)
//     {
//         $AI4 = 0;
//     }
// }

/////////////////////////////////////////////////////////////////////////

file_put_contents('datas_moxa.log', "FORAGE ". $ID ." : ". $DI1 . ", ". $DI2 .", ".  $DI3 .", ". $DI4 . ", ". $AI1 . ", ". $AI2 . ", ". $AI3 .", ". $AI4 .", ". $SR ."\n", FILE_APPEND);

if ($DI1 == 1)
{
    $DI1_STAT="MARCHE";
    $DI1_STAT_NUM=1;
    if (file_exists($file_pointer)) { // VERIFICATION FICHIER INITIALISATION DEMARRAGE - PREFIXE PAR LE NUMERO DE SERIE
        //echo "Le fichier $filename existe.";
        file_put_contents('datas_moxa.log', "Moteur toujours en marche \n", FILE_APPEND);
    } else {
        if (file_exists($file_pointer_old))
            {
                file_put_contents('datas_moxa.log', "*************** MOTEUR REDEMARRE à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
                $last_duration = file_get_contents($file_pointer_old);
                $new_uptime = $timestamp_uptime - $last_duration;
                file_put_contents($file_pointer_old, $new_uptime);
                rename($file_pointer_old, $file_pointer);
            }
        else {

                file_put_contents('moxa_'.$SR, $timestamp_uptime); //INITIALISATION DE L'HEURE DEBUT DE MARCHE
                file_put_contents('datas_moxa.log', "Moteur démarré à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID." ".$date." MOTEUR DEMARRE\n", FILE_APPEND);
            }
    }
}

if ($DI1 == 0) // ETAT ALARME AVEC "DI" DESACTIVEPOUR ARRET
{
    $DI1_STAT="ARRET";
    $DI1_STAT_NUM=0;
    if (file_exists($file_pointer))
            {
                $last_uptime = file_get_contents($file_pointer);
                $last_duration = $timestamp_uptime - $last_uptime;
                file_put_contents($file_pointer, $last_duration);
                rename($file_pointer, $file_pointer_old);
                file_put_contents('datas_moxa.log', "Moteur arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID." ".$date." MOTEUR ARRETE\n", FILE_APPEND);
            }
        else {
                file_put_contents('datas_moxa.log', "Moteur arrêté à ".$date."\n", FILE_APPEND);
                file_put_contents('notes.log', $ID." ".$date." MOTEUR ARRETE\n", FILE_APPEND);
            }
}

if ($DI2 == 1)
{
    $DI2_STAT="DEFAUT";
    $DI2_STAT_NUM=1;
    file_put_contents('datas_moxa.log', "*************** DEFAUT MOTEUR\n", FILE_APPEND);
    file_put_contents('notes.log', $ID." ".$date." DEFAUT MOTEUR\n", FILE_APPEND);
}
else
{
    $DI2_STAT="OK";
    $DI2_STAT_NUM=0;
    file_put_contents('datas_moxa.log', "Pas de defeaut moteur\n", FILE_APPEND);
}

if ($DI3 == 0)
{
    $DI3_STAT="DEFAUT";
    $DI3_STAT_NUM=0;
    file_put_contents('datas_moxa.log', "*************** DEFAUT TENSION\n", FILE_APPEND);
    file_put_contents('notes.log', $ID." ".$date." DEFAUT TENSION\n", FILE_APPEND);
}
else
{
    $DI3_STAT="OK";
    $DI3_STAT_NUM=1;
    file_put_contents('datas_moxa.log', "TENSION OK\n", FILE_APPEND);
}


$load = "moxa_".$SR.",nom=".$ID." AI1=".$AI1.",DI1=".$DI1.",DI2=".$DI2.",DI1S=\"".$DI1_STAT."\",DI1S_NUM=".$DI1_STAT_NUM.",DI2S=\"".$DI2_STAT."\",DI2S_NUM=".$DI2_STAT_NUM.",DI3S=\"".$DI3_STAT."\",DI3S_NUM=".$DI3_STAT_NUM.",name=\"".$ID."\",AI2=".$AI2;
//load = "moxa_".$SR.",nom=".$ID." AI1=".$AI1.",DI1=".$DI1.",DI2=".$DI2.",DI1S=\"".$DI1_STAT."\",DI2S=\"".$DI2_STAT."\",DI3S=\"".$DI3_STAT."\",name=\"".$ID."\",AI2=".$AI2;
$response1 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load'");
file_put_contents('datas_moxa.log', "Ecriture sur BD done!!!\n", FILE_APPEND);


?>
v
