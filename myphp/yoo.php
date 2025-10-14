<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');


//$w1 = $_POST['w1'];
//$w2 = $_POST['w2'];

//$data = array(
 //'filter' => array (
  //'date_from' => $_POST['date_from'],
  //'date_to' => $_POST['date_to'],
  //'status' => "NEW"
  //)
//);


$pfAdapterUser = "1042687";
$pfAdapterPasswd = "test_yLDRGm80QxkaP08V5n4tyc22zkiwK0tRrYg1s9hbpxI";


$data = array(
  'amount' => array (
     'value' => "100.00",
     'currency' => "RUB"
  ),
  'capture' => true,
  'confirmation' => array (
     'type' => "redirect",
     'return_url' => "https://codebeautify.org/json-decode-online"
  ),
  'description' => "Заказ №1"
);


$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://api.yookassa.ru/v3/payments");
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data, JSON_UNESCAPED_UNICODE));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$headers = [
    'Idempotence-Key: 8D8AC610-566D-4EF0-9C22-186B2A5ED793',
    'Content-Type: application/json'
];

curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_USERPWD, self::$pfAdapterUser.":".self::$pfAdapterPasswd);
curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);




$server_output = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
print $http_code .'!*'. $server_output;


?>


$order_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
 
$ch = curl_init('https://api.yookassa.ru/v3/payments/' . $order_id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_USERPWD, 'ЛОГИН:КЛЮЧ');
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Idempotence-Key: ' . gen_uuid()));
$res = curl_exec($ch);
curl_close($ch);
	
$res = json_decode($res, true);
print_r($res);