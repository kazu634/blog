+++
title = "JavaScriptではじめるWebマップアプリケーション: Chapter2-2"
date = 2019-05-01T21:07:08+07:00
description = "JavaScriptではじめるWebマップアプリケーションの内容を淡々と試してみます。"
categories = ["Map"]
author = "kazu634"
images = ["ogp/003-setup-dev-environment.webp"]
tags = ["mapbox.js"]
+++

『[JavaScriptではじめるWebマップアプリケーション \(PDF版\)](https://booth.pm/ja/items/1314906)』の内容を淡々と試してみます。`Mapbox GL JS`で地図を表示してみます:

<div id="mapbox-map"></div>

<script src="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.js"></script>
<link href="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.css" rel="stylesheet">

<style type="text/css">
<!--
#mapbox-map {
  height: 600px;
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

});

// ズームコントロール
let nc = new mapboxgl.NavigationControl();
map.addControl(nc, 'top-left');
</script>

## コード
こんな形になります:

```
<div id="mapbox-map"></div>

<script src="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.js"></script>
<link href="https://api.tiles.mapbox.com/mapbox-gl-js/v0.52.0/mapbox-gl.css" rel="stylesheet">

<style type="text/css">
<!--
#mapbox-map {
  height: 600px;
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

});

// ズームコントロール
let nc = new mapboxgl.NavigationControl();
map.addControl(nc, 'top-left');
</script>
```
