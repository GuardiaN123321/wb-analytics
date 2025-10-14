<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');

function gen_uuid() {
	return sprintf( '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
		mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),
		mt_rand( 0, 0xffff ),
		mt_rand( 0, 0x0fff ) | 0x4000,
		mt_rand( 0, 0x3fff ) | 0x8000,
		mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
	);
}

$data = array(
	'amount' => array(
 		'value' => $_POST['value'],
 		'currency' => 'RUB',
 	),
 	'capture' => true,
 	'confirmation' => array(
 		'type' => 'redirect',
 		'return_url' => 'https://s222885.h1n.ru/return/',
 	),
	'description' => $_POST['description'],
	'metadata' => array(
 		'order_id' => $_POST['order_id'],
 	)
);
 
$data = json_encode($data, JSON_UNESCAPED_UNICODE);
 	
$ch = curl_init('https://api.yookassa.ru/v3/payments');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_USERPWD, '1045634:live_PtOfNTo-2aw4l8KWaOfeA2UMQPaJIMG4RPXoaZ8MPW4');
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Idempotence-Key: ' . gen_uuid()));
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data); 	
$res = curl_exec($ch);
curl_close($ch);	
	
//$res = json_decode($res, true);
print_r($res);

?>