<?php

// Démo sur Scriptol.fr
$remote_ip = $_SERVER["REMOTE_ADDR"] ?? '127.0.0.1';
$date = date('Y-m-d H:i:s');
foreach (getallheaders() as $name => $value) {
    file_put_contents('data_sms.php', $name." => ".$value."\n", FILE_APPEND);
    echo "$name: $value\n";
}


foreach ($_POST as $key => $value) {

        file_put_contents('data_sms.php', "HEADER > ".$key." => ".$value."\n", FILE_APPEND);

    }
$message = explode("\n", $_POST["message"]);

file_put_contents('data_sms.php', "MESSAGE 0 ".$message[0]."\n", FILE_APPEND);
file_put_contents('data_sms.php', "MESSAGE 1 ".$message[1]."\n", FILE_APPEND);
file_put_contents('data_sms.php', "MESSAGE 2 ".$message[2]."\n", FILE_APPEND);
//if ($message == "BACKWAGOTEST")

?>
