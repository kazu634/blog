+++
title="Leaflet.jsでMapboxのタイルを用いて地図を表示する"
date=2019-04-08
publishdate=2019-04-08
Description="Leaflet.jsでMapboxのタイルを用いて地図を表示するよ"
image="https://farm9.staticflickr.com/8462/29581774242_bf25a0a820_z.jpg"
leaflet=true
+++

[Leaflet.js](https://leafletjs.com/)でMapboxのタイルを用いて地図を表示してみます:

<div id="mapid"></div>

<script>
  var mymap = L.map('mapid').setView([35.7142, 139.7774], 13)

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoia2F6dTYzNCIsImEiOiJjanU4OHg0YjIyMjcxNDNsb2dnM2k5bHhqIn0.dsjWTh-G_TcJ9bOGWLvT2Q', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1Ijoia2F6dTYzNCIsImEiOiJjanU4OHg0YjIyMjcxNDNsb2dnM2k5bHhqIn0.dsjWTh-G_TcJ9bOGWLvT2Q'
  }).addTo(mymap);

  var marker = L.marker([35.7142, 139.7774]).addTo(mymap);
  marker.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
</script>

## コード
こんな感じになります:

```
<div id="mapid"></div>

<script>
  var mymap = L.map('mapid').setView([35.7142, 139.7774], 13)

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=<access_token>' {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'access_token'
  }).addTo(mymap);

  var marker = L.marker([35.7142, 139.7774]).addTo(mymap);
  marker.bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
</script>
```

