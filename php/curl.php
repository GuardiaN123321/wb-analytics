<?php
// Разрешение браузеру на осуществление кроссдоменных запросов
header('Access-Control-Allow-Origin: *');
header('Content-type: application/json; charset=utf-8');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token, X-Requested-With');

// Для отладки - логируем запросы
file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - Запрос: ' . $_SERVER['QUERY_STRING'] . "\n", FILE_APPEND);

// Проверяем, есть ли параметр url в запросе
if (isset($_GET['url'])) {
    $url = $_GET['url'];
    
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
    
    // Выполняем запрос
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    
    // Логируем ответ для отладки
    file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - HTTP код: ' . $http_code . "\n", FILE_APPEND);
    
    // Проверяем на ошибки
    if (curl_errno($ch)) {
        $error = ['error' => 'Ошибка curl: ' . curl_error($ch)];
        file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - Ошибка: ' . curl_error($ch) . "\n", FILE_APPEND);
        echo json_encode($error);
    } else {
        // Возвращаем ответ клиенту
        if ($http_code == 200) {
            // Проверяем валидность JSON
            $json_check = json_decode($response);
            if (json_last_error() === JSON_ERROR_NONE) {
                echo $response;
                
                // Логируем краткую информацию об ответе
                $sample = substr($response, 0, 100) . '...';
                file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - Ответ: ' . $sample . "\n", FILE_APPEND);
            } else {
                $error = ['error' => 'Ответ сервера не является валидным JSON: ' . json_last_error_msg()];
                file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - Ошибка JSON: ' . json_last_error_msg() . "\n", FILE_APPEND);
                echo json_encode($error);
            }
        } else {
            $error = ['error' => 'HTTP код ответа: ' . $http_code];
            file_put_contents('curl_log.txt', date('Y-m-d H:i:s') . ' - Ошибка HTTP: ' . $http_code . "\n", FILE_APPEND);
            echo json_encode($error);
        }
    }
    
    curl_close($ch);
} else {
    // Если параметр url не указан, возвращаем ошибку
    echo json_encode(['error' => 'Не указан параметр url']);
}
?> 