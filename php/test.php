<?php
// Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: application/json; charset=utf-8');

// Артикул товара для тестирования
$articleId = '179913362';

// URL для запроса к API
$url = "https://wbxcatalog-ru.wildberries.ru/nm-2-card/catalog?spp=0&regions=64,75,4,38,30,33,70,66,40,22,31,71,68,80,1,69,48&stores=117673,122258,122259,125238,125239,125240,2737,117501,507,3158,117986,1733,686,132043&pricemarginCoeff=1.0&reg=1&appType=1&emp=0&locale=ru&lang=ru&curr=rub&couponsGeo=12,3,18,15,21&dest=-1029256,-102269,-2162196,-1257786&nm={$articleId}";

// Альтернативный URL
$alt_url = "https://card.wb.ru/cards/detail?appType=1&curr=rub&dest=-1029256,-102269,-2162196,-1257786&nm={$articleId}&reg=1&spp=0";

// Настраиваем curl для запроса
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HEADER, false);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);

// Устанавливаем заголовки для имитации запроса от браузера
$headers = [
    'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
    'Accept: application/json, text/plain, */*',
    'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7',
    'Accept-Encoding: gzip, deflate, br',
    'Referer: https://www.wildberries.ru/',
    'Origin: https://www.wildberries.ru',
    'Connection: keep-alive',
    'Sec-Fetch-Dest: empty',
    'Sec-Fetch-Mode: cors',
    'Sec-Fetch-Site: cross-site',
    'Pragma: no-cache',
    'Cache-Control: no-cache'
];

curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_ENCODING, 'gzip, deflate');

// Результаты тестов
$results = [
    'timestamp' => date('Y-m-d H:i:s'),
    'tests' => []
];

// Тест основного API
$test1 = [
    'api' => 'wbxcatalog-ru',
    'url' => $url
];

// Выполняем запрос
$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if (curl_errno($ch)) {
    $test1['success'] = false;
    $test1['error'] = 'Ошибка curl: ' . curl_error($ch);
} else {
    $test1['http_code'] = $http_code;
    
    if ($http_code == 200) {
        $json_check = json_decode($response);
        if (json_last_error() === JSON_ERROR_NONE) {
            $test1['success'] = true;
            $test1['json_valid'] = true;
            
            // Проверяем наличие товара
            if (isset($json_check->data->products) && count($json_check->data->products) > 0) {
                $test1['product_found'] = true;
                $test1['product_info'] = [
                    'name' => $json_check->data->products[0]->name ?? 'Н/Д',
                    'brand' => $json_check->data->products[0]->brand ?? 'Н/Д'
                ];
            } else {
                $test1['product_found'] = false;
            }
            
            // Сохраняем первые 200 символов ответа
            $test1['response_sample'] = substr($response, 0, 200) . '...';
        } else {
            $test1['success'] = false;
            $test1['json_valid'] = false;
            $test1['json_error'] = json_last_error_msg();
            $test1['response_sample'] = substr($response, 0, 200) . '...';
        }
    } else {
        $test1['success'] = false;
    }
}

$results['tests'][] = $test1;

// Тест альтернативного API
curl_setopt($ch, CURLOPT_URL, $alt_url);

$test2 = [
    'api' => 'card.wb.ru',
    'url' => $alt_url
];

// Выполняем запрос
$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if (curl_errno($ch)) {
    $test2['success'] = false;
    $test2['error'] = 'Ошибка curl: ' . curl_error($ch);
} else {
    $test2['http_code'] = $http_code;
    
    if ($http_code == 200) {
        $json_check = json_decode($response);
        if (json_last_error() === JSON_ERROR_NONE) {
            $test2['success'] = true;
            $test2['json_valid'] = true;
            
            // Проверяем наличие товара
            if (isset($json_check->data->products) && count($json_check->data->products) > 0) {
                $test2['product_found'] = true;
                $test2['product_info'] = [
                    'name' => $json_check->data->products[0]->name ?? 'Н/Д',
                    'brand' => $json_check->data->products[0]->brand ?? 'Н/Д'
                ];
            } else {
                $test2['product_found'] = false;
            }
            
            // Сохраняем первые 200 символов ответа
            $test2['response_sample'] = substr($response, 0, 200) . '...';
        } else {
            $test2['success'] = false;
            $test2['json_valid'] = false;
            $test2['json_error'] = json_last_error_msg();
            $test2['response_sample'] = substr($response, 0, 200) . '...';
        }
    } else {
        $test2['success'] = false;
    }
}

$results['tests'][] = $test2;

curl_close($ch);

// Возвращаем результаты тестов
echo json_encode($results, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?> 