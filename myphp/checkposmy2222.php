<?php
// Разрешение кроссдоменных запросов и настройка кодировки
header('Access-Control-Allow-Origin: *');
header('Content-type: text/html; charset=utf-8');
$headers = ['Content-type: text/html; charset=utf-8'];

// Получение и кодирование данных из POST
$data = urlencode($_POST['data']);
$find = $_POST['find']; // Не кодируем, так как ищем числовой ID

// Массив городов с их идентификаторами
$cities = [
    'wh1' => '-1257218', // Москва
    'wh2' => '-1198055', // Санкт-Петербург
    'wh3' => '12358058', // Краснодар
    'wh4' => '-2133462', // Казань
    'wh5' => '123589409', // Екатеринбург
];

// Инициализация мультикурла
$mh = curl_multi_init();
$handles = [];

// Создание запросов для каждого города и страницы
foreach ($cities as $cityKey => $cityId) {
    for ($page = 1; $page <= 5; $page++) {
        $url = "https://search.wb.ru/exactmatch/ru/common/v9/search?ab_testing=false&appType=128&curr=rub&dest={$cityId}&page={$page}&query={$data}&resultset=catalog&sort=popular&spp=30&suppressSpellcheck=false";
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_HTTPHEADER      => $headers,
            CURLOPT_RETURNTRANSFER  => true,
            CURLOPT_SSL_VERIFYPEER  => false,
            CURLOPT_HEADER          => false,
            CURLOPT_HTTP_VERSION    => CURL_HTTP_VERSION_3ONLY,
            CURLOPT_PRIVATE         => json_encode(['city' => $cityKey, 'page' => $page])
        ]);
        curl_multi_add_handle($mh, $ch);
        $handles[] = $ch;
    }
}

// Выполнение запросов
do {
    curl_multi_exec($mh, $running);
    curl_multi_select($mh);
} while ($running > 0);

// Обработка результатов
$results = [];
foreach ($handles as $ch) {
    $privateData = json_decode(curl_getinfo($ch, CURLINFO_PRIVATE), true);
    $cityKey = $privateData['city'];
    $page = $privateData['page'];
    $response = json_decode(curl_multi_getcontent($ch));
    $products = $response->data->products ?? [];

    // Поиск позиции товара
    foreach ($products as $pos => $product) {
        if ($product->id == $find) {
            $results[$cityKey][$page] = $pos;
            break;
        }
    }

    // Очистка ресурсов
    curl_multi_remove_handle($mh, $ch);
    curl_close($ch);
}
curl_multi_close($mh);

// Формирование результата
$output = [];
foreach ($cities as $cityKey => $cityId) {
    for ($page = 1; $page <= 5; $page++) {
        if (isset($results[$cityKey][$page])) {
            $output[] = $results[$cityKey][$page] . $cityKey . 'p' . $page;
        }
    }
}

// Вывод результатов
echo implode('=#=', $output);
?>