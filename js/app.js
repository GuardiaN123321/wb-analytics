document.addEventListener('DOMContentLoaded', function() {
    // Элементы интерфейса
    const productList = document.getElementById('productList');
    const emptyState = document.getElementById('emptyState');
    const addButton = document.getElementById('addButton');
    const addModal = document.getElementById('addModal');
    const closeModal = document.getElementById('closeModal');
    const articleInput = document.getElementById('articleInput');
    const addProductButton = document.getElementById('addProductButton');
    const scanButton = document.getElementById('scanButton');
    
    // Загружаем сохраненные товары при запуске
    loadProducts();
    
    // Обработчики событий
    addButton.addEventListener('click', function() {
        openModal();
    });
    
    closeModal.addEventListener('click', function() {
        closeModalWindow();
    });
    
    addProductButton.addEventListener('click', function() {
        addProduct();
    });
    
    scanButton.addEventListener('click', function() {
        // Здесь можно добавить функциональность сканирования штрих-кода
        // с использованием API камеры для мобильных устройств
        alert('Функция сканирования в разработке');
    });
    
    // Закрытие модального окна при клике вне его области
    window.addEventListener('click', function(event) {
        if (event.target === addModal) {
            closeModalWindow();
        }
    });
    
    // Функция для открытия модального окна
    function openModal() {
        addModal.classList.add('active');
        articleInput.focus();
    }
    
    // Функция для закрытия модального окна
    function closeModalWindow() {
        addModal.classList.remove('active');
        articleInput.value = '';
    }
    
    // Функция для добавления нового товара
    function addProduct() {
        const articleId = articleInput.value.trim();
        
        if (!articleId) {
            alert('Введите артикул товара');
            return;
        }
        
        // Проверяем, существует ли уже товар с таким артикулом
        const products = getProductsFromStorage();
        if (products.some(p => p.article === articleId)) {
            alert('Товар с таким артикулом уже добавлен');
            return;
        }
        
        // Показываем индикатор загрузки
        addProductButton.textContent = 'Загрузка...';
        addProductButton.disabled = true;
        
        // Получаем информацию о товаре
        fetchProductInfo(articleId)
            .then(productData => {
                if (productData && !productData.error) {
                    // Сохраняем товар в localStorage
                    saveProduct(productData);
                    
                    // Обновляем список товаров
                    loadProducts();
                    
                    // Закрываем модальное окно
                    closeModalWindow();
                } else {
                    alert('Не удалось найти товар с указанным артикулом');
                }
            })
            .catch(error => {
                console.error('Ошибка при получении информации о товаре:', error);
                alert('Произошла ошибка при получении информации о товаре');
            })
            .finally(() => {
                // Восстанавливаем кнопку
                addProductButton.textContent = 'Добавить';
                addProductButton.disabled = false;
            });
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
                    reviews: product.feedbacks ? product.feedbacks.count : 0,
                    addedAt: Date.now()
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
    
    // Функция для сохранения товара в localStorage
    function saveProduct(product) {
        const products = getProductsFromStorage();
        products.push(product);
        localStorage.setItem('wb_products', JSON.stringify(products));
    }
    
    // Функция для удаления товара из localStorage
    function removeProduct(articleId) {
        const products = getProductsFromStorage();
        const updatedProducts = products.filter(p => p.article !== articleId);
        localStorage.setItem('wb_products', JSON.stringify(updatedProducts));
    }
    
    // Функция для получения списка товаров из localStorage
    function getProductsFromStorage() {
        const productsJson = localStorage.getItem('wb_products');
        return productsJson ? JSON.parse(productsJson) : [];
    }
    
    // Функция для загрузки списка товаров
    function loadProducts() {
        const products = getProductsFromStorage();
        
        // Очищаем список
        productList.innerHTML = '';
        
        // Отображаем пустое состояние, если нет товаров
        if (products.length === 0) {
            productList.appendChild(emptyState);
            return;
        }
        
        // Скрываем пустое состояние
        if (emptyState.parentNode) {
            emptyState.parentNode.removeChild(emptyState);
        }
        
        // Сортируем товары по дате добавления (новые сверху)
        products.sort((a, b) => b.addedAt - a.addedAt);
        
        // Создаем элементы для каждого товара
        products.forEach(product => {
            const productCard = createProductCard(product);
            productList.appendChild(productCard);
        });
    }
    
    // Функция для создания карточки товара
    function createProductCard(product) {
        const card = document.createElement('div');
        card.className = 'product-card';
        card.dataset.article = product.article;
        
        const imageContainer = document.createElement('div');
        imageContainer.className = 'product-card-image';
        
        const image = document.createElement('img');
        image.src = product.image;
        image.alt = product.name;
        image.onerror = function() {
            this.src = 'other/null.png'; // Заменяем на заглушку при ошибке загрузки
        };
        
        imageContainer.appendChild(image);
        card.appendChild(imageContainer);
        
        const info = document.createElement('div');
        info.className = 'product-card-info';
        
        const title = document.createElement('div');
        title.className = 'product-card-title';
        title.textContent = product.name;
        
        const meta = document.createElement('div');
        meta.className = 'product-card-meta';
        meta.textContent = `Артикул: ${product.article} • ${product.brand}`;
        
        const stats = document.createElement('div');
        stats.className = 'product-card-stats';
        
        const priceItem = createStatItem('Цена', `${product.price.toLocaleString()} ₽`);
        const stockItem = createStatItem('Остаток', product.stock);
        
        stats.appendChild(priceItem);
        stats.appendChild(stockItem);
        
        info.appendChild(title);
        info.appendChild(meta);
        info.appendChild(stats);
        
        card.appendChild(info);
        
        // Обработчик клика по карточке
        card.addEventListener('click', function() {
            window.location.href = `product.html?article=${product.article}`;
        });
        
        return card;
    }
    
    // Функция для создания элемента статистики
    function createStatItem(label, value) {
        const item = document.createElement('div');
        item.className = 'product-card-stat';
        
        const labelEl = document.createElement('div');
        labelEl.className = 'stat-label';
        labelEl.textContent = label;
        
        const valueEl = document.createElement('div');
        valueEl.className = 'stat-value';
        valueEl.textContent = value;
        
        item.appendChild(labelEl);
        item.appendChild(valueEl);
        
        return item;
    }
    
    // Запускаем обновление данных о товарах раз в час
    setInterval(updateProductsData, 60 * 60 * 1000);
    
    // Функция для обновления данных о товарах
    async function updateProductsData() {
        const products = getProductsFromStorage();
        
        if (products.length === 0) return;
        
        console.log('Обновление данных о товарах...');
        
        // Обновляем данные для каждого товара
        for (const product of products) {
            try {
                const updatedData = await fetchProductInfo(product.article);
                
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
                }
            } catch (error) {
                console.error(`Ошибка при обновлении данных для товара ${product.article}:`, error);
            }
        }
        
        // Сохраняем обновленные данные
        localStorage.setItem('wb_products', JSON.stringify(products));
        
        // Обновляем отображение, если пользователь находится на главной странице
        loadProducts();
        
        console.log('Данные о товарах обновлены');
    }
}); 