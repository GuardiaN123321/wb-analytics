document.addEventListener('DOMContentLoaded', function() {
    // Элементы интерфейса
    const backButton = document.getElementById('backButton');
    const refreshButton = document.getElementById('refreshButton');
    const productImage = document.getElementById('productImage');
    const productName = document.getElementById('productName');
    const productArticle = document.getElementById('productArticle');
    const productBrand = document.getElementById('productBrand');
    const productPrice = document.getElementById('productPrice');
    const productStock = document.getElementById('productStock');
    const productReviews = document.getElementById('productReviews');
    const productPosition = document.getElementById('productPosition');
    const updateButton = document.getElementById('updateButton');
    const shareButton = document.getElementById('shareButton');
    
    // Получаем артикул товара из URL
    const urlParams = new URLSearchParams(window.location.search);
    const articleId = urlParams.get('article');
    
    if (!articleId) {
        window.location.href = 'index.html';
        return;
    }
    
    // Загружаем информацию о товаре
    loadProductDetails(articleId);
    
    // Обработчики событий
    backButton.addEventListener('click', function() {
        window.location.href = 'index.html';
    });
    
    refreshButton.addEventListener('click', function() {
        loadProductDetails(articleId, true);
    });
    
    updateButton.addEventListener('click', function() {
        loadProductDetails(articleId, true);
    });
    
    shareButton.addEventListener('click', function() {
        // Формируем текст для шаринга
        const shareText = `${productName.textContent}\nАртикул: ${productArticle.textContent}\nЦена: ${productPrice.textContent}\nОстаток: ${productStock.textContent}\nОтзывы: ${productReviews.textContent}`;
        
        // Пробуем использовать Web Share API, если доступно
        if (navigator.share) {
            navigator.share({
                title: 'Товар на Wildberries',
                text: shareText,
                url: window.location.href
            })
            .catch(error => {
                console.error('Ошибка при шаринге:', error);
                // Запасной вариант - копирование в буфер обмена
                copyToClipboard(shareText);
            });
        } else {
            // Если Web Share API не поддерживается, просто копируем в буфер обмена
            copyToClipboard(shareText);
        }
    });
    
    // Функция для копирования в буфер обмена
    function copyToClipboard(text) {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        document.body.appendChild(textarea);
        textarea.select();
        
        try {
            const successful = document.execCommand('copy');
            if (successful) {
                alert('Информация скопирована в буфер обмена!');
            } else {
                alert('Не удалось скопировать информацию');
            }
        } catch (err) {
            console.error('Ошибка при копировании в буфер обмена:', err);
            alert('Не удалось скопировать информацию');
        }
        
        document.body.removeChild(textarea);
    }
    
    // Функция для загрузки информации о товаре
    async function loadProductDetails(articleId, forceRefresh = false) {
        try {
            // Получаем товар из localStorage
            const products = getProductsFromStorage();
            let product = products.find(p => p.article === articleId);
            
            if (!product) {
                alert('Товар не найден');
                window.location.href = 'index.html';
                return;
            }
            
            // Обновляем информацию о товаре, если необходимо
            if (forceRefresh || shouldRefreshData(product)) {
                refreshButton.classList.add('spinning');
                
                const updatedData = await fetchProductInfo(articleId);
                
                if (updatedData && !updatedData.error) {
                    // Сохраняем историю предыдущих значений
                    if (!product.history) {
                        product.history = {};
                    }
                    
                    // Добавляем текущие значения в историю
                    const today = new Date().toISOString().split('T')[0];
                    
                    if (!product.history[today]) {
                        product.history[today] = {
                            price: product.price,
                            stock: product.stock,
                            reviews: product.reviews
                        };
                    }
                    
                    // Обновляем текущие значения
                    product.price = updatedData.price;
                    product.stock = updatedData.stock;
                    product.reviews = updatedData.reviews;
                    product.lastUpdated = Date.now();
                    
                    // Сохраняем обновленные данные
                    updateProductInStorage(product);
                }
                
                refreshButton.classList.remove('spinning');
            }
            
            // Отображаем информацию о товаре
            displayProductDetails(product);
            
            // Загружаем позицию товара в поисковой выдаче
            loadProductPosition(articleId, product.name);
            
            // Загружаем данные для графика
            loadChartData(articleId, product);
        } catch (error) {
            console.error('Ошибка при загрузке информации о товаре:', error);
            alert('Произошла ошибка при загрузке информации о товаре');
        }
    }
    
    // Функция для проверки необходимости обновления данных
    function shouldRefreshData(product) {
        if (!product.lastUpdated) return true;
        
        const now = Date.now();
        const lastUpdated = product.lastUpdated;
        const hoursSinceLastUpdate = (now - lastUpdated) / (1000 * 60 * 60);
        
        return hoursSinceLastUpdate >= 1; // Обновляем, если прошло больше часа
    }
    
    // Функция для отображения информации о товаре
    function displayProductDetails(product) {
        document.title = `${product.name} - Аналитика Маркетплейсов`;
        
        productImage.src = product.image;
        productImage.alt = product.name;
        productImage.onerror = function() {
            this.src = 'other/null.png'; // Заменяем на заглушку при ошибке загрузки
        };
        
        productName.textContent = product.name;
        productArticle.textContent = product.article;
        productBrand.textContent = product.brand;
        productPrice.textContent = `${product.price.toLocaleString()} ₽`;
        productStock.textContent = product.stock;
        productReviews.textContent = product.reviews;
    }
    
    // Функция для получения информации о товаре
    async function fetchProductInfo(articleId) {
        try {
            // Получаем URL изображения товара
            const imageUrl = makeProductImageUrl(articleId);
            
            // Формируем URL запроса к работающему Wildberries API
            const apiUrl = `https://card.wb.ru/cards/detail?appType=1&curr=rub&dest=-1029256,-102269,-2162196,-1257786&nm=${articleId}&reg=1&spp=0`;
            
            // Получаем данные о товаре через наш прокси
            console.log('Отправка запроса к API:', apiUrl);
            const response = await fetch(`php/curl.php?url=${encodeURIComponent(apiUrl)}`);
            
            // Проверяем статус ответа
            if (!response.ok) {
                console.error('Ошибка HTTP:', response.status, response.statusText);
                return { error: `Ошибка HTTP: ${response.status}` };
            }
            
            const data = await response.json();
            console.log('Ответ API:', data);
            
            if (data.error) {
                console.error('Ошибка API:', data.error);
                return { error: data.error };
            }
            
            if (data.data && data.data.products && data.data.products.length > 0) {
                const product = data.data.products[0];
                
                // Формируем объект с информацией о товаре
                return {
                    article: articleId,
                    name: product.name,
                    brand: product.brand,
                    image: imageUrl,
                    price: product.salePriceU / 100,
                    stock: calculateTotalStock(product.sizes),
                    reviews: product.feedbacks ? product.feedbacks.count : 0
                };
            } else {
                console.error('Товар не найден в ответе API:', data);
                return { error: 'Товар не найден' };
            }
        } catch (error) {
            console.error('Ошибка при получении информации о товаре:', error);
            return { error: 'Ошибка при получении информации о товаре: ' + error.message };
        }
    }
    
    // Функция для расчета общего количества товара
    function calculateTotalStock(sizes) {
        if (!sizes || !sizes.length) return 0;
        
        return sizes.reduce((total, size) => {
            if (!size.stocks || !size.stocks.length) return total;
            return total + size.stocks.reduce((sizeTotal, stock) => sizeTotal + stock.qty, 0);
        }, 0);
    }
    
    // Функция для генерации URL изображения товара
    function makeProductImageUrl(productId) {
        const nm = parseInt(productId, 10);
        const vol = Math.floor(nm / 1e5);
        const part = Math.floor(nm / 1e3);
        let host = '';
        
        if (vol >= 0 && vol <= 143) host = '01';
        else if (vol >= 144 && vol <= 287) host = '02';
        else if (vol >= 288 && vol <= 431) host = '03';
        else if (vol >= 432 && vol <= 719) host = '04';
        else if (vol >= 720 && vol <= 1007) host = '05';
        else if (vol >= 1008 && vol <= 1061) host = '06';
        else if (vol >= 1062 && vol <= 1115) host = '07';
        else if (vol >= 1116 && vol <= 1169) host = '08';
        else if (vol >= 1170 && vol <= 1313) host = '09';
        else if (vol >= 1314 && vol <= 1601) host = '10';
        else if (vol >= 1602 && vol <= 1655) host = '11';
        else if (vol >= 1656 && vol <= 1919) host = '12';
        else if (vol >= 1920 && vol <= 2045) host = '13';
        else if (vol >= 2046 && vol <= 2189) host = '14';
        else if (vol >= 2190 && vol <= 2405) host = '15';
        else if (vol >= 2406 && vol <= 2621) host = '16';
        else if (vol >= 2622 && vol <= 2837) host = '17';
        else if (vol >= 2838 && vol <= 3053) host = '18';
        else if (vol >= 3054 && vol <= 3269) host = '19';
        else if (vol >= 3270 && vol <= 3485) host = '20';
        else host = '21';
        
        return `https://basket-${host}.wbbasket.ru/vol${vol}/part${part}/${nm}/images/big/1.webp`;
    }
    
    // Функция для получения списка товаров из localStorage
    function getProductsFromStorage() {
        const productsJson = localStorage.getItem('wb_products');
        return productsJson ? JSON.parse(productsJson) : [];
    }
    
    // Функция для обновления товара в localStorage
    function updateProductInStorage(updatedProduct) {
        const products = getProductsFromStorage();
        const index = products.findIndex(p => p.article === updatedProduct.article);
        
        if (index !== -1) {
            products[index] = updatedProduct;
            localStorage.setItem('wb_products', JSON.stringify(products));
        }
    }
    
    // Функция для загрузки позиции товара в поисковой выдаче
    async function loadProductPosition(articleId, productName) {
        try {
            // Создаем поисковый запрос из названия товара (берем первые 3 слова)
            const searchQuery = productName.split(' ').slice(0, 3).join(' ');
            
            // Получаем позицию товара
            const response = await fetch(`php/position.php?article=${articleId}&query=${encodeURIComponent(searchQuery)}`);
            const data = await response.json();
            
            if (data.found) {
                productPosition.textContent = `${data.position} (стр. ${data.page})`;
            } else {
                productPosition.textContent = 'Не найден в топ-100';
            }
        } catch (error) {
            console.error('Ошибка при получении позиции товара:', error);
            productPosition.textContent = 'Ошибка';
        }
    }
    
    // Функция для загрузки данных для графика
    async function loadChartData(articleId, product) {
        try {
            // Получаем исторические данные
            const response = await fetch(`php/history.php?article=${articleId}`);
            const data = await response.json();
            
            if (data.error) {
                console.error('Ошибка при получении исторических данных:', data.error);
                return;
            }
            
            // Подготавливаем данные для графика
            const chartData = {
                title: `Динамика показателей товара ${articleId}`,
                labels: data.dates.join(', '),
                prices: data.prices.join(', '),
                stocks: data.stocks.join(', '),
                reviews: data.reviews.join(', ')
            };
            
            // Сохраняем данные в глобальные переменные для ECharts
            window.runtime = {
                globalVars: {
                    title: chartData.title,
                    data0: chartData.prices,
                    data1: chartData.stocks,
                    data2: chartData.reviews,
                    labels2: chartData.labels,
                    findOne: articleId
                },
                callFunction: function(name) {
                    console.log(`Вызов функции: ${name}`);
                }
            };
            
            // Загружаем и инициализируем ECharts
            loadECharts();
        } catch (error) {
            console.error('Ошибка при загрузке данных для графика:', error);
        }
    }
    
    // Функция для загрузки ECharts
    function loadECharts() {
        if (typeof echarts !== "undefined") {
            console.log("✅ ECharts уже загружен!");
            initChart();
            return;
        }
        
        console.log("⏳ Загружаем ECharts...");
        
        var script = document.createElement("script");
        script.src = "https://fastly.jsdelivr.net/npm/echarts@5.5.1/dist/echarts.min.js";
        script.onload = function() {
            console.log("🎉 ECharts загружен!");
            initChart();
        };
        script.onerror = function() {
            console.error("❌ Ошибка загрузки ECharts!");
        };
        document.head.appendChild(script);
    }
    
    // Функция для инициализации графика
    function initChart() {
        console.log("Готовимся создать график...");
        
        var dom = document.getElementById("chart-container");
        if (!dom) {
            console.error("Ошибка: Элемент #chart-container не найден!");
            return;
        }
        
        dom.style.width = "100%";
        dom.style.height = "300px";
        
        var myChart = echarts.init(dom);
        
        const str1 = runtime.globalVars.data0;
        const words1 = str1.split(", ");
        const str2 = runtime.globalVars.data1;
        const words2 = str2.split(", ");
        const str3 = runtime.globalVars.data2;
        const words3 = str3.split(", ");
        const str4 = runtime.globalVars.labels2;
        const words4 = str4.split(", ");
        
        var option = {
            tooltip: {
                trigger: 'axis',
                textStyle: {
                    color: "#000000",
                    fontSize: 14,
                    fontWeight: "normal",
                    fontFamily: 'Rubik-Regular',
                }
            },
            title: {
                left: 'center',
                top: '5px',
                text: runtime.globalVars.title,
                textStyle: {
                    color: "#000000",
                    fontSize: 16,
                    fontWeight: "bold",
                    fontFamily: 'Rubik-Regular',
                }
            },
            legend: {
                top: 30,
                data: ['Цена', 'Остаток', 'Отзывы'],
                icon: "roundRect",
                selected: {
                    'Цена': true,
                    'Остаток': true,
                    'Отзывы': true
                },
                textStyle: {
                    color: "#000000",
                    fontSize: 14,
                    fontWeight: "normal",
                    fontFamily: 'Rubik-Regular',
                }
            },
            grid: {
                height: '75%',
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                data: words4,
                axisLabel: {
                    textStyle: {
                        color: "#000000",
                        fontSize: 12,
                        fontWeight: "normal",
                        fontFamily: 'Rubik-Regular',
                    }
                }
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: function(val) {
                        if (val >= 1000000) {
                            return `${val / 1000000}M`;
                        }
                        if (val >= 1000 && val < 1000000) {
                            return `${val / 1000}K`;
                        }
                        return val;
                    },
                    textStyle: {
                        color: "#000000",
                        fontSize: 12,
                        fontWeight: "normal",
                        fontFamily: 'Rubik-Regular',
                    }
                }
            },
            series: [
                {
                    name: 'Цена',
                    type: 'line',
                    smooth: true,
                    areaStyle: {},
                    data: words1,
                    itemStyle: {
                        color: '#7232f2'
                    },
                    areaStyle: {
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [{
                                offset: 0, color: 'rgba(114, 50, 242, 0.5)'
                            }, {
                                offset: 1, color: 'rgba(114, 50, 242, 0.1)'
                            }]
                        }
                    }
                },
                {
                    name: 'Остаток',
                    type: 'line',
                    smooth: true,
                    areaStyle: {},
                    data: words2,
                    itemStyle: {
                        color: '#2f80ed'
                    },
                    areaStyle: {
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [{
                                offset: 0, color: 'rgba(47, 128, 237, 0.5)'
                            }, {
                                offset: 1, color: 'rgba(47, 128, 237, 0.1)'
                            }]
                        }
                    }
                },
                {
                    name: 'Отзывы',
                    type: 'line',
                    smooth: true,
                    areaStyle: {},
                    data: words3,
                    itemStyle: {
                        color: '#27ae60'
                    },
                    areaStyle: {
                        color: {
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 0,
                            y2: 1,
                            colorStops: [{
                                offset: 0, color: 'rgba(39, 174, 96, 0.5)'
                            }, {
                                offset: 1, color: 'rgba(39, 174, 96, 0.1)'
                            }]
                        }
                    }
                }
            ]
        };
        
        myChart.setOption(option);
        
        window.addEventListener("resize", () => myChart.resize());
        
        console.log("✅ График успешно создан!");
    }
}); 