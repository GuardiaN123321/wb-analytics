function fetchCardData(nm) {

    const requestUrl = `https://th0mas.invizi.ru/curl4.php?url=`+nm;

    fetch(requestUrl, {

        method: 'GET',

    })

        .then(response => {

            if (!response.ok) {

                throw new Error('Ошибка запроса: ' + response.status);
                
            }

            return response.json(); // Если ответ в формате JSON

        })

        .then(data => {

            runtime.globalVars.datas=JSON.stringify(data);
            runtime.globalVars.lets2=1;

        })

        .catch(error => {

            console.error('Произошла ошибка:', error.message);

        });

}

var r = fetchCardData(runtime.globalVars.findOne);