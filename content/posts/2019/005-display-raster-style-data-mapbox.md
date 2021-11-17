+++
title = "JavaScriptではじめるWebマップアプリケーション: Chapter3-2"
date = 2019-06-29T18:41:00+07:00
description = "JavaScriptではじめるWebマップアプリケーションの内容を淡々と試してみます。"
categories = ["Map"]
author = "kazu634"
tags = ["mapbox"]
+++

『[JavaScriptではじめるWebマップアプリケーション \(PDF版\)](https://booth.pm/ja/items/1314906)』の内容を淡々と試してみます。`Mapbox.js`でラスタ形式の地図を表示してみます:

<nav id="menu"></nav>
<div id="mapbox-map"></div>

<script src="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.js"></script>
<link href="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.css" rel="stylesheet">

<style type="text/css">
<!--
#mapbox-map {
  height: 600px;
}

#menu {
  background: #fff;
  position: absolute;
  z-index: 1;
  top: 10px;
  right: 10px;
  border-radius: 3px;
  width: 180px;
  border: 1px solid rgba(0,0,0,0.4);
}

#menu a{
  font-size: 13 px;
  color: #404040;
  display: block;
  margin: 0;
  padding: 10px;
  text-decoration: none;
  border-bottom: 1px solid rgba(0,0,0,0.25);
  text-align: centerl
}

#menu a:last-child {
  border: none;
}

#menu a:hover {
  background-color: #f8f8f8;
  color: #404040;
}

#menu a.active {
  background-color: #8DCF3F;
  color: #ffffff;
}

#menu a.active:hover {
  background: #79bb2b;
}
-->
</style>

<script>
// MIERUNE MONO読み込み
let map = new mapboxgl.Map({
    container: "mapbox-map",
    style: {
        version: 8,
        sources: {
            m_mono: {
                type: "raster",
                tiles: ["https://tile.mierune.co.jp/mierune_mono/{z}/{x}/{y}.png"],
                tileSize: 256
            }
        },
        layers: [{
            id: "m_mono",
            type: "raster",
            source: "m_mono",
            minzoom: 0,
            maxzoom: 18
        }]
    },
    center: [139.7670, 35.6810],
    zoom: 13
});

map.on("load", function() {

  // MIERUNE Color 読み込み
  map.addSource("m_color", {
    type: "raster",
    tiles: ["https://tile.mierune.co.jp/mierune/{z}/{x}/{y}.png"],
    tileSize: 256
  });
  map.addLayer({
    id: "m_color",
    type: "raster",
    source: "m_color",
    minzoom: 0,
    maxzoom: 18
  });

  // 地理院タイル 淡色読み込み
  map.addSource("t_pale", {
    type: "raster",
    tiles: ["http://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png"],
    tileSize: 256
  });
  map.addLayer({
    id: "t_pale",
    type: "raster",
    source: "t_pale",
    minzoom: 0,
    maxzoom: 18
  });

  // 地理院タイル オルソ読み込み
  map.addSource("t_ort", {
    type: "raster",
    tiles: ["http://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg"],
    tileSize: 256
  });
  map.addLayer({
    id: "t_ort",
    type: "raster",
    source: "t_ort",
    minzoom: 0,
    maxzoom: 18
  });

  // OpenStreetMap 読み込み
  map.addSource("o_std", {
    type: "raster",
    tiles: [
      "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
      "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png"
    ],
    tileSize: 256
  });
  map.addLayer({
    id: "o_std",
    type: "raster",
    source: "o_std",
    minzoom: 0,
    maxzoom: 18
  });

  // レイヤ設定
  let Map_BaseLayer = {
    m_mono: "MIERUNE MONO",
    m_color: "MIERUNE Color",
    t_pale: "地理院タイル 淡色",
    t_ort: "地理院タイル オルソ",
    o_std: "OpenStreetMap"
  };

  // レイヤメニュー作成
  for (let i = 0; i < Object.keys(Map_BaseLayer).length; i++) {
    // レイヤID取得
    let id = Object.keys(Map_BaseLayer)[i];
    // aタグ作成
    let link = document.createElement("a");
    link.href = "#";
    // id追加
    link.id = id;
    // 名称追加
    link.textContent = Map_BaseLayer[id];

    // 初期表示 m_mono 以外非表示
    if (id === "m_mono") {
      link.className = "active";
    } else {
      map.setLayoutProperty(id, "visibility", "none");
      link.className = "";
    }

    // aタグクリック処理
    link.onclick = function (e) {
      // id取得
      let clickedLayer = this.id;
      e.preventDefault();
      e.stopPropagation();

      // ON/OFF状態取得
      let visibility = map.getLayoutProperty(clickedLayer, "visibility");

      // ON/OFF 判断
      if (visibility === "visible") {
      } else {
        for (let j = 0; j < Object.keys(Map_BaseLayer).length; j++) {
          // レイヤID取得
          let ch_id = Object.keys(Map_BaseLayer)[j];

          // レイヤの表示・非表示
          if (ch_id === clickedLayer) {
            // クリックしたレイヤを表示
            this.className = "active";
            map.setLayoutProperty(clickedLayer, "visibility", "visible");
          } else {
            // クリックしたレイヤ以外を非表示
            let ch_obj = document.getElementById(ch_id);
            ch_obj.className = "";
            map.setLayoutProperty(ch_id, "visibility", "none");
          }
        }
      }
    };

    // レイヤメニューにレイヤ追加
    let layers = document.getElementById("menu");
    layers.appendChild(link);
  };
});

// ズームコントロール
let nc = new mapboxgl.NavigationControl();
map.addControl(nc, 'top-left');
</script>

