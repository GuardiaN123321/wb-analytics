// Функция для загрузки ECharts
function loadECharts(callback) {
    if (typeof echarts !== "undefined") {
        console.log("✅ ECharts уже загружен!");
        callback();
        return;
    }

    console.log("⏳ Загружаем ECharts...");

    var script = document.createElement("script");
    script.src = "https://fastly.jsdelivr.net/npm/echarts@5.5.1/dist/echarts.min.js";
    script.onload = function () {
        console.log("🎉 ECharts загружен!");
        callback();
    };
    script.onerror = function () {
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

    dom.style.width = "98%";
    dom.style.height = "300px";

    var myChart = echarts.init(dom);
	
	//var myChart = echarts.init(dom, null, {
      //renderer: 'canvas',
     // useDirtyRect: false
    //});

    //var app = {};
    const str1 = runtime.globalVars.data0;
	const words1 = str1.split(", ");
	const str2 = runtime.globalVars.data1;
	const words2 = str2.split(", ");
	const str3 = runtime.globalVars.data2;
	const words3 = str3.split(", ");
	const str4 = runtime.globalVars.labels2;
	const words4 = str4.split(", ");
    //let legends = ['Цена', 'Остаток', 'Отзывы']
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
  height:'75%',
  left: '3%',
  right: '4%',
  bottom: '3%',
  containLabel: true
  },

  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: [words4[0], words4[1], words4[2], words4[3], words4[4], words4[5], words4[6], words4[7], words4[8], words4[9], words4[10], words4[11], words4[12], words4[13], words4[14], words4[15], words4[16], words4[17], words4[18], words4[19], words4[20], words4[21], words4[22], words4[23], words4[24], words4[25], words4[26], words4[27]],

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
      
	  formatter:
	  function (val) {
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
      data: [words1[0], words1[1], words1[2], words1[3], words1[4], words1[5], words1[6], words1[7], words1[8], words1[9], words1[10], words1[11], words1[12], words1[13], words1[14], words1[15], words1[16], words1[17], words1[18], words1[19], words1[20], words1[21], words1[22], words1[23], words1[24], words1[25], words1[26], words1[27]]
    },
    {
      name: 'Остаток',
      type: 'line',

      smooth: true,
      areaStyle: {},
      data: [words2[0], words2[1], words2[2], words2[3], words2[4], words2[5], words2[6], words2[7], words2[8], words2[9], words2[10], words2[11], words2[12], words2[13], words2[14], words2[15], words2[16], words2[17], words2[18], words2[19], words2[20], words2[21], words2[22], words2[23], words2[24], words2[25], words2[26], words2[27]]
    },
    {
      name: 'Отзывы',
      type: 'line',

      smooth: true,
      areaStyle: {},
      data: [words3[0], words3[1], words3[2], words3[3], words3[4], words3[5], words3[6], words3[7], words3[8], words3[9], words3[10], words3[11], words3[12], words3[13], words3[14], words3[15], words3[16], words3[17], words3[18], words3[19], words3[20], words3[21], words3[22], words3[23], words3[24], words3[25], words3[26], words3[27]]
    }
  ]
    };

    myChart.setOption(option);

    window.addEventListener("resize", () => myChart.resize());

    console.log("✅ График успешно создан!");
	
	if (words2[27] <= words2[26]) {
	//console.log(words2[26] - words2[27]);
    runtime.globalVars.vikup = words2[26] - words2[27];
	//console.log(runtime.globalVars.vikup);
	runtime.globalVars.vir = Math.round((runtime.globalVars.vikup * words1[27])-(runtime.globalVars.vikup * words1[27] * 16) / 100);
	runtime.callFunction('set_new');
	}

	//else {
	//console.log("✅ Наоборот!");
	//}

}

// Ожидаем появления контейнера в DOM и загружаем ECharts
const observer = new MutationObserver(() => {
    var container = document.getElementById("chart-container");
    if (container) {
        console.log("🎉 Контейнер найден! Загружаем ECharts...");
        observer.disconnect(); // Останавливаем наблюдение
        loadECharts(initChart); // Загружаем ECharts перед запуском графика
		//runtime.callFunction('set_new');
    }
});

// Запускаем наблюдение за изменениями в `body`
observer.observe(document.body, { childList: true, subtree: true });


	//const ost = runtime.globalVars.data1;
	//const getost = ost.split(", ");

//if ([getost[27]] !== "undefined") {
        
    //}