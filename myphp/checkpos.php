<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: text/html; charset=utf-8');

$headers = ['Content-type: text/html; charset=utf-8']; // заголовки нашего запроса


$data = urlencode($_POST['data']);
$data2 = urlencode($_POST['data2']);
$data3 = urlencode($_POST['data3']);

$ch = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page='.$data2.'&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HEADER, false);
$html = curl_exec($ch);
curl_close($ch);
 
echo $html;
?>