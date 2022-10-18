<?php

$remote_ip = $_SERVER["REMOTE_ADDR"] ?? '127.0.0.1';
$date = date('Y-m-d H:i:s');
foreach (getallheaders() as $name => $value) {
    file_put_contents('datas_moxa_event.log', $name." => ".$value."\n", FILE_APPEND);
    echo "$name: $value\n";
}


foreach ($_POST as $key => $value) {

        file_put_contents('datas_moxa_event.log', "HEADER > ".$key." => ".$value."\n", FILE_APPEND);

    }

file_put_contents('datas_moxa_event.log', $remote_ip." => ".$date."\n", FILE_APPEND);

$entityBody = file_get_contents('php://input');

file_put_contents('datas_moxa_event.log', $entityBody."\n", FILE_APPEND);

$table = json_decode($entityBody);
$ID = $table->{'ID'};
$SR = $table->{'serial'};

file_put_contents('datas_moxa_event.log', $table->{'ID'} ."\n", FILE_APPEND);
$array = json_decode($entityBody, true);
foreach($array as $key => $val) {
  if ($key == "DI1")
  {
     if ($val == 0)
     {
        $DI1S="ARRET";
        $DI1=$val;
        $DI1_STAT_NUM=0;
     } else {
        $DI1S="MARCHE";
        $DI1=$val;
        $DI1_STAT_NUM=1;
     }
  }
  if ($key == "DI2")
  {
     if ($val == 0)
     {
        $DI2S="OK";
        $DI2=$val;
        $DI2_STAT_NUM=0;
     } else {
        $DI2S="DEFAUT";
        $DI2=$val;
        $DI2_STAT_NUM=1;
     }
  }
  if ($key == "DI3")
  {
     if ($val == 0)
     {
        $DI3S="DEFAUT";
        $DI3=$val;
        $DI3_STAT_NUM=0;
     } else {
        $DI3S="OK";
        $DI3=$val;
        $DI1_STAT_NUM=1;
     }
  }
  if ($key == "DI4")
  {
     $DI4=$val;
  }
  if ($key == "AI1")
  {
     file_put_contents('datas_moxa_event.log', "VAL ON AI1\n", FILE_APPEND);
     $DI4=$val;
  }
}
$load = "moxa_".$SR.",nom=".$ID." AI1=".$AI1.",DI1=".$DI1.",DI2=".$DI2.",DI1S=\"".$DI1_STAT."\",DI1S_NUM=".$DI1_STAT_NUM.",DI2S=\"".$DI2_STAT."\",DI2S_NUM=".$DI2_STAT_NUM.",DI3S=\"".$DI3_STAT."\",DI3S_NUM=".$DI3_STAT_NUM.",name=\"".$ID."\"";
file_put_contents('datas_moxa_event.log', $load."\n", FILE_APPEND);
$response1 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load'");
file_put_contents('datas_moxa_event.log', "Ecriture sur BD done!!!\n", FILE_APPEND);


?>
