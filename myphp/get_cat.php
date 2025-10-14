<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: text/html; charset=utf-8');

$headers = ['Content-type: text/html; charset=utf-8']; // заголовки нашего запроса


$cat = $_POST['cat'];


$ch = curl_init($cat);
curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);

$html = curl_exec($ch);
curl_close($ch);

//echo $html;

//echo $yummy10->cards[0]->photos[0]->c246x328 .'=#=';


$yummy1 = json_decode($html);
//print_r($yummy1->subj_name);

print_r($yummy1->subj_name);


//echo $yummy1;


?>