function makeProductImageUrl(productId) {
    const nm = parseInt(productId, 10);
          const vol = ~~(nm / 1e5);
          const part = ~~(nm / 1e3);
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
          else if (vol >= 1920 && vol <= 2189) host = '14';
          else if (vol >= 1920 && vol <= 2405) host = '15';
          else if (vol >= 1920 && vol <= 2621) host = '16';
          else if (vol >= 1920 && vol <= 2837) host = '17';
          else if (vol >= 1920 && vol <= 3053) host = '18';
          else if (vol >= 1920 && vol <= 3269) host = '19';
          else if (vol >= 1920 && vol <= 3485) host = '20';
          else host = '21';
          return `https://basket-${host}.wbbasket.ru/vol${vol}/part${part}/${nm}/info/ru/card.json`;
  }
  
  // /images/big/1.webp
  
  
  //document.write(makeProductImageUrl(142562537));
  //console.log(makeProductImageUrl(142562537));
  
  runtime.globalVars.my_cat = makeProductImageUrl(runtime.globalVars.findOne);
  //console.log(makeProductImageUrl(runtime.globalVars.findOne));
  //console.log(makeProductImageUrl(142562537));