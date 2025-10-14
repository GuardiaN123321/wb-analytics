<?php
// Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: application/json; charset=utf-8');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token, X-Requested-With');

// Получаем артикул товара из запроса
$articleId = isset($_GET['article']) ? $_GET['article'] : '';

if (empty($articleId)) {
    echo json_encode(['error' => 'Не указан артикул товара']);
    exit;
}

// Функция для получения данных о товаре из API Wildberries
function getProductData($articleId) {
    $apiUrl = "https://card.wb.ru/cards/detail?appType=1&curr=rub&dest=-1029256,-102269,-2162196,-1257786&nm={$articleId}&reg=1&spp=0";
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $apiUrl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
    
    $response = curl_exec($ch);
    curl_close($ch);
    
    if (!$response) {
        return null;
    }
    
    $data = json_decode($response, true);
    
    if (!isset($data['data']['products'][0])) {
        return null;
    }
    
    $product = $data['data']['products'][0];
    
    // Получаем остаток товара
    $stock = 0;
    if (isset($product['sizes']) && is_array($product['sizes'])) {
        foreach ($product['sizes'] as $size) {
            if (isset($size['stocks']) && is_array($size['stocks'])) {
                foreach ($size['stocks'] as $stockItem) {
                    $stock += isset($stockItem['qty']) ? (int)$stockItem['qty'] : 0;
                }
            }
        }
    }
    
    return [
        'price' => isset($product['salePriceU']) ? (int)$product['salePriceU'] / 100 : 0,
        'stock' => $stock,
        'reviews' => isset($product['feedbacks']['count']) ? (int)$product['feedbacks']['count'] : 0
    ];
}

// Получаем текущие данные о товаре из API
$currentData = getProductData($articleId);

if (!$currentData) {
    echo json_encode(['error' => 'Не удалось получить данные о товаре']);
    exit;
}

// Получаем текущую дату
$currentDate = new DateTime();
$currentDate->setTime(0, 0, 0);

// Создаем массивы для хранения данных за последние 30 дней
$dates = [];
$prices = [];
$stocks = [];
$reviews = [];

// Выводим в логи для отладки
error_log("Текущие данные о товаре {$articleId}: " . json_encode($currentData));

// Для демонстрации сразу используем актуальные данные (без симуляции истории)
for ($i = 29; $i >= 0; $i--) {
    $date = clone $currentDate;
    $date->modify("-$i days");
    
    // Добавляем дату в формате ДД.ММ
    $dates[] = $date->format('d.m');
    
    // Используем текущие данные для всех дат
    $prices[] = $currentData['price'];
    $stocks[] = $currentData['stock'];
    $reviews[] = $currentData['reviews'];
}

// Формируем ответ
$response = [
    'article' => $articleId,
    'dates' => $dates,
    'prices' => $prices,
    'stocks' => $stocks,
    'reviews' => $reviews,
    'current_data' => $currentData // Добавляем текущие данные для отладки
];

// Возвращаем результат
echo json_encode($response);
?> 