<?php
// Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: application/json; charset=utf-8');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token, X-Requested-With');

// Получаем параметры запроса
$articleId = isset($_GET['article']) ? $_GET['article'] : '';
$query = isset($_GET['query']) ? $_GET['query'] : '';

if (empty($articleId) || empty($query)) {
    echo json_encode(['error' => 'Не указан артикул товара или поисковый запрос']);
    exit;
}

// Функция для получения результатов поиска по запросу
function getSearchResults($query, $page = 1) {
    // Кодируем запрос для использования в URL
    $encodedQuery = urlencode($query);
    
    // Формируем URL для запроса
    $url = "https://search.wb.ru/exactmatch/ru/common/v4/search?appType=1&couponsGeo=12,3,18,15,21&curr=rub&dest=-1029256,-102269,-1278703,-1255563&emp=0&lang=ru&locale=ru&pricemarginCoeff=1.0&query={$encodedQuery}&reg=0&regions=68,64,83,4,38,80,33,70,82,86,75,30,69,22,66,31,40,1,48,71&resultset=catalog&sort=popular&spp=0&suppressSpellcheck=false&page={$page}";
    
    // Настраиваем curl для запроса
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
    
    // Выполняем запрос
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    
    // Проверяем на ошибки
    if (curl_errno($ch) || $http_code != 200) {
        curl_close($ch);
        return null;
    }
    
    curl_close($ch);
    return json_decode($response, true);
}

// Функция для поиска позиции товара
function findProductPosition($articleId, $query) {
    $position = 0;
    $maxPages = 10; // Максимальное количество страниц для поиска
    
    for ($page = 1; $page <= $maxPages; $page++) {
        $results = getSearchResults($query, $page);
        
        if (!$results || !isset($results['data']['products'])) {
            continue;
        }
        
        $products = $results['data']['products'];
        
        foreach ($products as $index => $product) {
            $position++;
            
            if ($product['id'] == $articleId) {
                return [
                    'position' => $position,
                    'page' => $page,
                    'found' => true
                ];
            }
        }
        
        // Если на странице нет результатов или это последняя страница
        if (count($products) == 0) {
            break;
        }
    }
    
    return [
        'position' => 0,
        'page' => 0,
        'found' => false
    ];
}

// Ищем позицию товара
$result = findProductPosition($articleId, $query);

// Возвращаем результат
echo json_encode($result);
?> 