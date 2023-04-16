import QtQuick 2.0
import Sailfish.Silica 1.0
import QtLocation 5.4
import QtPositioning 5.4
import MapboxMap 1.0

Page {
    id: stopmap
    property string linia
    property bool fit: false
    property string snum
    property var dlug
    property var szer
    property string tit
    property var arr: []
    property string typ: linia.length > 2 ? 1 : 2
    property string url: "https://api.um.warszawa.pl/api/action/busestrams_get/?resource_id=f2e5503e-927d-4ad3-9500-4ab9e55deb59&apikey=8c2d8817-cd66-4785-a25f-777b58b5ae94&line=" + linia + "&type=" + typ
    function updatelist(){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                for (var i=0;i<data.result.length;i++) {
                    if (!fit){
                        addPoint( data.result[i].Lon, data.result[i].Lat, i, data.result[i].VehicleNumber);
                    } else {
                        recolor(data.result.length);
                        addPoint( data.result[i].Lon, data.result[i].Lat, i +data.result.length, data.result[i].VehicleNumber );
                    }
                    arr.push(QtPositioning.coordinate(data.result[i].Lat, data.result[i].Lon));
                }
                if(!fit){
                    map.fitView(arr);
                    fit = true
                }
            }
        }
        xhr.send();
    }
    function recolor(j){
        for (var i=0;i<j;i++) {
            map.setPaintProperty("location" + i, "circle-color", "gray")
        }
    }
    function addPoint(dlug, szer, num, vnum){
        snum =  " (" + vnum + ")"
        map.addSource("location" + num,
                      {"type": "geojson", "data": {
                              "type": "Feature",
                              "properties": { "name": "location" + num},
                              "geometry": {
                                  "type": "Point",
                                  "coordinates": [
                                      parseFloat(dlug), parseFloat(szer)
                                  ]
                              }
                          }
                      });
        map.addLayer("location" + num, {"type": "circle", "source": "location" + num})
        map.setPaintProperty("location" + num, "circle-radius", 10)
        map.setPaintProperty("location" + num, "circle-color", "red")
        map.addLayer("location-label" + num, {"type": "symbol", "source": "location" + num})
        map.setLayoutProperty("location-label" + num, "text-field", snum)
        map.setLayoutProperty("location-label" + num, "text-justify", "left")
        map.setLayoutProperty("location-label" + num, "text-anchor", "top-left")
        map.setPaintProperty("location-label" + num, "text-halo-color", "white")
        map.setPaintProperty("location-label" + num, "text-halo-width", 2)
    }
    Column {
        width: parent.width
        height: parent.height
        PageHeader {
            id: header
            title: !linia ? tit : linia
        }
        Rectangle {
            id : mapview
            anchors.left: parent.left
            anchors.right: parent.right
            height: stopmap.height - header.height
            MapboxMap {
                id: map
                z: 1
                minimumZoomLevel: 0
                maximumZoomLevel: 20
                center: QtPositioning.coordinate(szer, dlug);
                pixelRatio: 1.5
                anchors.fill: parent
                styleUrl: "http://localhost:8553/v1/mbgl/style?style=osmbright"
                MapboxMapGestureArea {
                    map: map
                }
                Component.onCompleted: {
                    zoomLevel = !linia ? 17 : 12

                    map.addSource("location",
                                  {"type": "geojson", "data": {
                                          "type": "Feature",
                                          "properties": { "name": "location"},
                                          "geometry": {
                                              "type": "Point",
                                              "coordinates": [
                                                  parseFloat(dlug), parseFloat(szer)
                                              ]
                                          }
                                      }
                                  });

                    map.addLayer("location-case", {"type": "circle", "source": "location"}, "waterway-name")
                    map.setPaintProperty("location-case", "circle-radius", 20)
                    map.setPaintProperty("location-case", "circle-color", "white")
                    map.addLayer("location", {"type": "circle", "source": "location"})
                    map.setPaintProperty("location", "circle-radius", 15)
                    map.setPaintProperty("location", "circle-color", "blue")
                    map.addLayer("location-label", {"type": "symbol", "source": "location"})
                    map.setLayoutProperty("location-label", "text-allow-overlap", true)
                    map.setLayoutProperty("location-label", "icon-allow-overlap", true)
                    map.setLayoutProperty("location-label", "icon-image", "position-icon")
                    map.setLayoutProperty("location-label", "text-field", tit)
                    map.setLayoutProperty("location-label", "text-justify", "left")
                    map.setLayoutProperty("location-label", "text-anchor", "top-left")
                    map.setPaintProperty("location-label", "text-halo-color", "white")
                    map.setPaintProperty("location-label", "text-halo-width", 5)
                    if(linia) updatelist();
                }
            }
        }
        Timer {
            id: timer
            interval : 10000
            running : linia
            repeat : linia
            onTriggered : {
                updatelist()
            }
        }
    }
}
