+++
title="Leaflet.jsでMapboxのタイルを用いて地図を表示する"
date=2019-04-08
publishdate=2019-04-08
description="Leaflet.jsでMapboxのタイルを用いて地図を表示するよ"
images = ["https://farm9.staticflickr.com/8462/29581774242_bf25a0a820_z.jpg"]
leaflet=true
tags = []
+++

[Leaflet.js](https://leafletjs.com/)でMapboxのタイルを用いて地図を表示してみます:

{{< leaflet-map id="mapid" lat="35.7142" long="139.7774" >}}

{{< leaflet-marker lat="35.7142" long="139.7774" msg="上野駅だよ" >}}

{{< leaflet-circle lat="35.7237" long="139.7653" >}}

<script>
	var polygon = L.polygon([
	    [35.7173, 139.7657],
	    [35.7142, 139.7774],
	    [35.7068, 139.7700]
	]).addTo(mymap);
</script>

<script>
	function onEachFeature(feature, layer) {
	    // does this feature have a property named popupContent?
	    if (feature.properties && feature.properties.popupContent) {
	        layer.bindPopup(feature.properties.popupContent);
	    }
	}

	var geojsonFeature = {
	    "type": "Feature",
	    "properties": {
	        "name": "御徒町駅",
	        "amenity": "駅",
	        "popupContent": "御徒町駅だよ"
	    },
	    "geometry": {
	        "type": "Point",
	        "coordinates": [139.7734, 35.7080]
	    }
	};

	L.geoJSON(geojsonFeature, {
	    onEachFeature: onEachFeature
	}).addTo(mymap);
</script>

<script>
	function onEachFeature(feature, layer) {
	    // does this feature have a property named popupContent?
	    if (feature.properties && feature.properties.popupContent) {
	        layer.bindPopup(feature.properties.popupContent);
	    }
	}

	var geojsonFeature = {
	    "type": "Feature",
	    "properties": {
	        "name": "御徒町駅",
	        "amenity": "駅",
	        "popupContent": "御徒町駅だよ"
	    },
	    "geometry": {
	        "type": "Point",
	        "coordinates": [139.7734, 35.7080]
	    }
	};

	L.geoJSON(geojsonFeature, {
	    onEachFeature: onEachFeature
	}).addTo(mymap);
</script>

{{< leaflet-topojson url="https://raw.githubusercontent.com/dataofjapan/land/master/tokyo.topojson" >}}

## コード
チュートリアルなどにしたがって進めてみます。

### 地図を表示する
チュートリアルなどに従って地図を表示してみました。国土地理院・Open Street Map・Mapboxの3つのタイルを切り替えられるようにしてみました。

地図は上野駅が中心になるように指定しています。

```
<div id='mapid'></div>

<script>
	// タイルレイヤーを作成する
	var cyberjapandata = L.tileLayer('https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png', {
		  maxZoom: 18,
		  attribution: '&copy; <a href="https://maps.gsi.go.jp/development/ichiran.html" target="_blank">国土地理院</a>',
		  }),
		openstreetmap = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
		  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
		  }),
		mapbox = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoia2F6dTYzNCIsImEiOiJjanU4OHg0YjIyMjcxNDNsb2dnM2k5bHhqIn0.dsjWTh-G_TcJ9bOGWLvT2Q', {
		    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
		    maxZoom: 18,
		    id: 'mapbox.streets',
		    accessToken: 'pk.eyJ1Ijoia2F6dTYzNCIsImEiOiJjanU4OHg0YjIyMjcxNDNsb2dnM2k5bHhqIn0.dsjWTh-G_TcJ9bOGWLvT2Q'
		  });

	var baseMaps = {
	    "国土地理院": cyberjapandata,
	    "OpenStreetMap": openstreetmap,
	    "Mapbox": mapbox
	};

	// 地図を作成する
	var mymap = L.map('mapid', {layers: [cyberjapandata]});
	L.control.layers(baseMaps).addTo(mymap);

	// 地図の中心座標とズームレベルを設定する
	mymap.setView([35.7142,139.7774], 13);
</script>
```

### マーカーを設置する
以下のように指定して、マーカーを設置します:

```
<script>
  var marker = L.marker(["35.7142", "139.7774"]).addTo(mymap);
  marker.bindPopup("上野駅だよ").openPopup();
</script>
```

### サークルを設置する
以下のように指定して、サークルを設置します:

```
<script>
	var circle = L.circle([35.7237, 139.7653], {
	    color: 'red',
	    fillColor: '#f03',
	    fillOpacity: 0.5,
	    radius: 500
	}).addTo(mymap);
</script>
```

### ポリゴンを設置する
複数の経度・緯度を指定し、その点を結んだ図形を描画します。

```
<script>
	var polygon = L.polygon([
	    [35.7173, 139.7657],
	    [35.7142, 139.7774],
	    [35.7068, 139.7700]
	]).addTo(mymap);
</script>
```

### GeoJSONからデータを読み込んで描画する
こんな感じで描画できます:

```
<script>
	function onEachFeature(feature, layer) {
	    // does this feature have a property named popupContent?
	    if (feature.properties && feature.properties.popupContent) {
	        layer.bindPopup(feature.properties.popupContent);
	    }
	}

	var geojsonFeature = {
	    "type": "Feature",
	    "properties": {
	        "name": "御徒町駅",
	        "amenity": "駅",
	        "popupContent": "御徒町駅だよ"
	    },
	    "geometry": {
	        "type": "Point",
	        "coordinates": [139.7734, 35.7080]
	    }
	};

	L.geoJSON(geojsonFeature, {
	    onEachFeature: onEachFeature
	}).addTo(mymap);
</script>
```

### 外部のTopoJSONを読み込んで描画する
GeoJSONだけでなく、TopoJSONという形式もあるようです。ここでは外部のTopoJSONを読み込んで、描画してみます。

```
<script>
	// Changing topojson to geojson
	L.TopoJSON = L.GeoJSON.extend({
		addData: function(jsonData) {
			if (jsonData.type === "Topology") {
				for (let key in jsonData.objects) {
					if (jsonData.objects.hasOwnProperty(key)) {
						let geojson = topojson.feature(jsonData, jsonData.objects[key]);
						L.GeoJSON.prototype.addData.call(this, geojson);
					}
				}
			} else {
				L.GeoJSON.prototype.addData.call(this, jsonData);
			}
		}
	});

	const topoLayer = new L.TopoJSON();

	fetch('https://raw.githubusercontent.com/dataofjapan/land/master/tokyo.topojson')
		.then(response => {
			return response.json();
		})
		.then(data => {
			topoLayer.addData(data);
			topoLayer.addTo(mymap);
		});

</script>
```

## 参考
- [Tutorials - Leaflet - a JavaScript library for interactive maps](https://leafletjs.com/examples.html)
- [【JavaScript】fetchを使ったAPIデータの取得方法 | Web白熱教室](https://tsuyopon.xyz/2019/01/05/how-to-use-the-fetch-api-in-js/)
- [Maps with Leaflet,  TopoJSON &amp; Chroma](http://blog.webkid.io/maps-with-leaflet-and-topojson/)
- [leaflet.jsの地図に駅をプロットする - 小さなエンドウ豆](http://h-piiice16.hatenablog.com/entry/2017/06/11/104155)
- [オープンデータを地図上に表示してみる | 深ノオト](http://www.inqsite.net/weblog/4538/)
- [Leaflet.js を使って GeoJSON データを地図上に表示してみる その１ - Qiita](https://qiita.com/sin164/items/1ed25130fa5a1de00ea8)
- [GitHub - dataofjapan/land](https://github.com/dataofjapan/land)
- [GitHub - niiyz/JapanGeoGo: GeoJson of Japan.](https://github.com/niiyz/JapanGeoGo)
- [Continental GeoJson · GitHub](https://gist.github.com/cmunns/76fb72646a68202e6bde)

