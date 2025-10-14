<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');

//$ch = curl_init('https://api.yookassa.ru/v3/payments/2f53caed-000f-5000-8000-137190cf10fe');
//$ch = curl_init('https://api.yookassa.ru/v3/payments/' . $order_id);


function gen_uuid() {
	return sprintf( '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
		mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),
		mt_rand( 0, 0xffff ),
		mt_rand( 0, 0x0fff ) | 0x4000,
		mt_rand( 0, 0x3fff ) | 0x8000,
		mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
	);
}

$payment_id = $_POST['payment_id'];

$ch = curl_init('https://api.yookassa.ru/v3/payments/' . $payment_id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_USERPWD, '1045634:live_PtOfNTo-2aw4l8KWaOfeA2UMQPaJIMG4RPXoaZ8MPW4');
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Idempotence-Key: ' . gen_uuid()));
$res = curl_exec($ch);
curl_close($ch);
	
//$res = json_decode($res, true);
print_r($res);

?>