+++
title = "JavaScriptではじめるWebマップアプリケーション: Chapter3-1"
date = 2019-05-04T15:03:21+08:00
description = "JavaScriptではじめるWebマップアプリケーションの内容を淡々と試してみます。"
categories = ["Leaflet.js"]
author = "kazu634"
+++

『[JavaScriptではじめるWebマップアプリケーション \(PDF版\)](https://booth.pm/ja/items/1314906)』の内容を淡々と試してみます。`Leaflet.js`でラスタ形式の地図を表示してみます:

<div id="leaflet-map"></div>

<style type="text/css">
<!--
#leaflet-map { height: 600px; }
-->
</style>
<script src="https://unpkg.com/leaflet@1.3.4/dist/leaflet.js"></script>
<link href="https://unpkg.com/leaflet@1.3.4/dist/leaflet.css" rel="stylesheet">

<script>
// MIERUNE MONO読み込み
let m_mono = new L.tileLayer("https://tile.mierune.co.jp/mierune_mono/{z}/{x}/{y}.png", {
  attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org.copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// MIERUNE Color読み込み
let m_color = new L.tileLayer("https://tile.mierune.co.jp/mierune/{z}/{x}/{y}.png", {
  attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org.copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// 地理院タイル 単色読み込み
let t_pale = new L.tileLayer("https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png", {
  attribution: "<a href='http://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html' target='_blank'>国土地理院</a>"
});

// 地理院タイル オルソ読み込み
let t_ort = new L.tileLayer("https://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg", {
  attribution: "<a href='http://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html' target='_blank'>国土地理院</a>"
});

// OpenStreetMap 読み込み
let o_std = new L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: "<a href='http://osm.org/copyright' target='_blank'>OpenStreetMap</a> contributors"
});

// レイヤ設定
let Map_BaseLayer = {
  "MIERUNE MONO": m_mono,
  "MIERUNE Color": m_color,
  "地理院タイル 淡色": t_pale,
  "地理院タイル オルソ": t_ort,
  "OpenStreetMap": o_std
};

// Map読み込み
let map = L.map("leaflet-map", {
  center: [35.6810, 139.7670],
  zoom: 14,
  zoomControl: true,
  layers: [m_mono]
});

// レイヤコントロール
L.control.layers(Map_BaseLayer, null, {
  collapsed: false
}).addTo(map);
</script>


## コード
こんな形になります:

```
<div id="leaflet-map"></div>

<style type="text/css">
<!--
#leaflet-map { height: 600px; }
-->
</style>
<script src="https://unpkg.com/leaflet@1.3.4/dist/leaflet.js"></script>
<link href="https://unpkg.com/leaflet@1.3.4/dist/leaflet.css" rel="stylesheet">

<script>
// MIERUNE MONO読み込み
let m_mono = new L.tileLayer("https://tile.mierune.co.jp/mierune_mono/{z}/{x}/{y}.png", {
  attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org.copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// MIERUNE Color読み込み
let m_color = new L.tileLayer("https://tile.mierune.co.jp/mierune/{z}/{x}/{y}.png", {
  attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org.copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// 地理院タイル 単色読み込み
let t_pale = new L.tileLayer("https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png", {
  attribution: "<a href='http://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html' target='_blank'>国土地理院</a>"
});

// 地理院タイル オルソ読み込み
let t_ort = new L.tileLayer("https://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg", {
  attribution: "<a href='http://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html' target='_blank'>国土地理院</a>"
});

// OpenStreetMap 読み込み
let o_std = new L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: "<a href='http://osm.org/copyright' target='_blank'>OpenStreetMap</a> contributors"
});

// レイヤ設定
let Map_BaseLayer = {
  "MIERUNE MONO": m_mono,
  "MIERUNE Color": m_color,
  "地理院タイル 淡色": t_pale,
  "地理院タイル オルソ": t_ort,
  "OpenStreetMap": o_std
};

// Map読み込み
let map = L.map("leaflet-map", {
  center: [35.6810, 139.7670],
  zoom: 14,
  zoomControl: true,
  layers: [m_mono]
});

// レイヤコントロール
L.control.layers(Map_BaseLayer, null, {
  collapsed: false
}).addTo(map);
</script>
```
