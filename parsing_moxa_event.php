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
     file_put_contents('datas_moxa_event.log', "CHANGE ON DI1\n", FILE_APPEND);
     if ($val == 0)
     { 
        $val_str="ARRET";
     } else {
        $val_str="MARCHE";
     }
     $load = "moxa_".$SR.",nom=".$ID." DI1=".$val.",DI1S=\"".$val_str."\"";
  }
  if ($key == "DI2")
  {
     file_put_contents('datas_moxa_event.log', "CHANGE ON DI2\n", FILE_APPEND);
     if ($val == 0)
     {
        $val_str="OK";
     } else {
        $val_str="DEFAUT";
     }
     $load = "moxa_".$SR.",nom=".$ID." DI2=".$val.",DI2S=\"".$val_str."\""; 
  } 
  if ($key == "DI3")
  {
     file_put_contents('datas_moxa_event.log', "CHANGE ON DI3\n", FILE_APPEND);
     if ($val == 0)
     {
        $val_str="DEFAUT";
        file_put_contents('datas_moxa_event.log', "VAL DEFAUT = ".$val."\n", FILE_APPEND); 
     } else {
        $val_str="OK";
        file_put_contents('datas_moxa_event.log', "VAL OK = ".$val."\n", FILE_APPEND); 
     }
     $load = "moxa_".$SR.",nom=".$ID." DI3=".$val.",DI3S=\"".$val_str."\""; 
  } 
  if ($key == "DI4")
  {
     file_put_contents('datas_moxa_event.log', "CHANGE ON DI4\n", FILE_APPEND);
     $load = "moxa_".$SR.",nom=".$ID.",DI4=".$val;
  } 
}
file_put_contents('datas_moxa_event.log', $load."\n", FILE_APPEND);
$response1 = shell_exec("curl -i -XPOST http://0.0.0.0:8086/write?db=metrics_ics --data-binary '$load'");
file_put_contents('datas_moxa_event.log', "Ecriture sur BD done!!!\n", FILE_APPEND);


?>
