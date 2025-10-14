<?php
//Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: text/html; charset=utf-8');

$headers = ['Content-type: text/html; charset=utf-8']; // заголовки нашего запроса


$data = urlencode($_POST['data']);
//$data2 = urlencode($_POST['data2']);
//$data3 = urlencode($_POST['data3']);
$data3 = urlencode($_POST['data3']);

$find = urlencode($_POST['find']);


//$ch = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page='.$data2.'&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
//curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
//curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
//curl_setopt($ch, CURLOPT_HEADER, false);
//curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
//$html = curl_exec($ch);
//curl_close($ch);

//echo $html;




$ch_1 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=1&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_2 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=2&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_3 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=3&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_4 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=4&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_5 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=5&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');

/*$ch_6 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=6&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_7 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=7&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_8 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=8&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_9 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=9&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
$ch_10 = curl_init('https://search.wb.ru/exactmatch/ru/common/v7/search?ab_testing=false&appType=128&curr=rub&dest='.$data3.'&page=10&query='.$data.'&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false');
*/

curl_setopt($ch_1, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_2, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_3, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_4, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_5, CURLOPT_HTTPHEADER, $headers);

/*curl_setopt($ch_6, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_7, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_8, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_9, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch_10, CURLOPT_HTTPHEADER, $headers);*/


curl_setopt($ch_1, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_2, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_3, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_4, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_5, CURLOPT_RETURNTRANSFER, true);

/*curl_setopt($ch_6, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_7, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_8, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_9, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch_10, CURLOPT_RETURNTRANSFER, true);*/

curl_setopt($ch_1, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_2, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_3, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_4, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_5, CURLOPT_SSL_VERIFYPEER, false);

/*curl_setopt($ch_6, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_7, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_8, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_9, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch_10, CURLOPT_SSL_VERIFYPEER, false);*/

curl_setopt($ch_1, CURLOPT_HEADER, false);
curl_setopt($ch_2, CURLOPT_HEADER, false);
curl_setopt($ch_3, CURLOPT_HEADER, false);
curl_setopt($ch_4, CURLOPT_HEADER, false);
curl_setopt($ch_5, CURLOPT_HEADER, false);

/*curl_setopt($ch_6, CURLOPT_HEADER, false);
curl_setopt($ch_7, CURLOPT_HEADER, false);
curl_setopt($ch_8, CURLOPT_HEADER, false);
curl_setopt($ch_9, CURLOPT_HEADER, false);
curl_setopt($ch_10, CURLOPT_HEADER, false);*/

curl_setopt($ch_1, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_2, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_3, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_4, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_5, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);

/*curl_setopt($ch_6, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_7, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_8, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_9, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);
curl_setopt($ch_10, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_3ONLY);*/

$mh = curl_multi_init();

curl_multi_add_handle($mh, $ch_1);
curl_multi_add_handle($mh, $ch_2);
curl_multi_add_handle($mh, $ch_3);
curl_multi_add_handle($mh, $ch_4);
curl_multi_add_handle($mh, $ch_5);

/*curl_multi_add_handle($mh, $ch_6);
curl_multi_add_handle($mh, $ch_7);
curl_multi_add_handle($mh, $ch_8);
curl_multi_add_handle($mh, $ch_9);
curl_multi_add_handle($mh, $ch_10);*/
  
  
  $running = null;
  do {
	usleep(0);
    curl_multi_exec($mh, $running);
  } while ($running > 0);
   
  
curl_multi_remove_handle($mh, $ch1);
curl_multi_remove_handle($mh, $ch2);
curl_multi_remove_handle($mh, $ch3);
curl_multi_remove_handle($mh, $ch4);
curl_multi_remove_handle($mh, $ch5);

/*curl_multi_remove_handle($mh, $ch6);
curl_multi_remove_handle($mh, $ch7);
curl_multi_remove_handle($mh, $ch8);
curl_multi_remove_handle($mh, $ch9);
curl_multi_remove_handle($mh, $ch10);*/

curl_multi_close($mh);
  
$response_1 = curl_multi_getcontent($ch_1);
$response_2 = curl_multi_getcontent($ch_2);
$response_3 = curl_multi_getcontent($ch_3);
$response_4 = curl_multi_getcontent($ch_4);
$response_5 = curl_multi_getcontent($ch_5);

/*$response_6 = curl_multi_getcontent($ch_6);
$response_7 = curl_multi_getcontent($ch_7);
$response_8 = curl_multi_getcontent($ch_8);
$response_9 = curl_multi_getcontent($ch_9);
$response_10 = curl_multi_getcontent($ch_10);*/

$yummy1 = json_decode($response_1);
$yummy2 = json_decode($response_2);
$yummy3 = json_decode($response_3);
$yummy4 = json_decode($response_4);
$yummy5 = json_decode($response_5);

/*$yummy6 = json_decode($response_6);
$yummy7 = json_decode($response_7);
$yummy8 = json_decode($response_8);
$yummy9 = json_decode($response_9);
$yummy10 = json_decode($response_10);*/



//print_r($yummy1->data->products[0]->id) .'=#=';
//print_r($yummy1);
//$yummy1->data->products[0]->id


$json1=$yummy1->data->products;
$json2=$yummy2->data->products;
$json3=$yummy3->data->products;
$json4=$yummy4->data->products;
$json5=$yummy5->data->products;
/*
$json6=$yummy6->data->products;
$json7=$yummy7->data->products;
$json8=$yummy8->data->products;
$json9=$yummy9->data->products;
$json10=$yummy10->data->products;*/

//echo $find.'=#=';

foreach ($json1 as $key => $value) {
  if($value->id==$find){
    echo $key.'p1'.'=#=';
	break;
  }
}

foreach ($json2 as $key => $value) {
  if($value->id==$find){
    echo $key.'p2'.'=#=';
	break;
  }
}

foreach ($json3 as $key => $value) {
  if($value->id==$find){
    echo $key.'p3'.'=#=';
	break;
  }
}

foreach ($json4 as $key => $value) {
  if($value->id==$find){
    echo $key.'p4'.'=#=';
	break;
  }
}

foreach ($json5 as $key => $value) {
  if($value->id==$find){
    echo $key.'p5'.'=#=';
	break;
  }
}




/*foreach ($json6 as $key => $value) {
  if($value->id==$find){
    echo $key.'p6'.'=#=';
	break;
  }
}

foreach ($json7 as $key => $value) {
  if($value->id==$find){
    echo $key.'p7'.'=#=';
	break;
  }
}

foreach ($json8 as $key => $value) {
  if($value->id==$find){
    echo $key.'p8'.'=#=';
	break;
  }
}

foreach ($json9 as $key => $value) {
  if($value->id==$find){
    echo $key.'p9'.'=#=';
	break;
  }
}

foreach ($json10 as $key => $value) {
  if($value->id==$find){
    echo $key.'p10'.'=#=';
	break;
  }
}*/





//========================//
//$yummyww=json_encode(array_merge(json_decode($response_1, true),json_decode($response_2, true)));
//$asd = json_decode($yummyww);
//$dataw = json_encode((array)$asd);
//$asd2 = json_decode($dataw);
//print_r($asd2->data->products[0]->id);
//========================//

//print_r(array_replace_recursive($yummy1, $yummy2));


?>