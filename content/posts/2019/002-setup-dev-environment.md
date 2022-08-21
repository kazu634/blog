+++
title = "JavaScriptではじめるWebマップアプリケーション: Chapter2-1"
date = 2019-05-01T19:06:46+08:00
description = "JavaScriptではじめるWebマップアプリケーションの内容を淡々と試してみます。"
categories = ["Map"]
author = "kazu634"
images = ["ogp/002-setup-dev-environment.webp"]
tags = ["leaflet.js"]
+++

『[JavaScriptではじめるWebマップアプリケーション \(PDF版\)](https://booth.pm/ja/items/1314906)』の内容を淡々と試してみます。まずは`Leaflet.js`で地図を表示してみます:

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
attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org/copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// Map読み込み
let map = L.map("leaflet-map", {
center: [35.6810,139.7670],
zoom: 14,
layers: [m_mono]
});
</script>

## コード
このような形になります:

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
attribution: "Maptiles by <a href='http://mierune.co.jp/' target='_blank'>MIERUNE</a>, under CC BY. Data by <a href='http://osm.org/copyright' target='_blank'>OpenStreetMap</a> contributors, under ODbL."
});

// Map読み込み
let map = L.map("leaflet-map", {
center: [35.6810,139.7670],
zoom: 14,
layers: [m_mono]
});
</script>
```
