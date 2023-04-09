import QtQuick 2.0
import Sailfish.Silica 1.0
import QtLocation 5.4
import QtPositioning 5.4
import MapboxMap 1.0


Page {
    id: stopmap
    width: parent.width
    height: parent.height

    property var dlug
    property var szer
    property string tit
    property string typ: linia.length > 2 ? 1 : 2
    property string url: "https://api.um.warszawa.pl/api/action/busestrams_get/?resource_id=f2e5503e-927d-4ad3-9500-4ab9e55deb59&apikey=8c2d8817-cd66-4785-a25f-777b58b5ae94&line=" + linia + "&type=" + typ
    Column {
                width: stopmap.width
        height: stopmap.height
  PageHeader {
            id: header
            title: tit
    }
    Rectangle {
        id : mapview
            //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
                anchors.bottom: stopmap.bottom
            height: stopmap.height - header.height
        MapboxMap {
            id: map
            z: 1
            minimumZoomLevel: 0
            maximumZoomLevel: 20
            center: QtPositioning.coordinate(szer, dlug);
                pixelRatio: 1.5

            anchors.fill: parent
            zoomLevel: 17

        styleUrl: "http://localhost:8553/v1/mbgl/style?style=osmbright"
        MapboxMapGestureArea {
            map: map
        }
            Component.onCompleted: {
            //    center = QtPositioning.coordinate(szer, dlug);
                zoomLevel = 17
            console.log(parseFloat(szer), parseFloat(dlug))
            map.addSource("location",
                  {"type": "geojson", "data": {
                "type": "Feature",
                "properties": { "name": "location"},
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                  //  (21.043690),(52.250228)
                       parseFloat(dlug), parseFloat(szer)
                    //    dlug, szer
                        ]
                }
            }
        });
                    /*
            map.addLayer("location-uncertainty", {"type": "circle", "source": "location"}, "waterway-name")
            map.setPaintProperty("location-uncertainty", "circle-radius", 120)
            map.setPaintProperty("location-uncertainty", "circle-color", "#87cefa")
            map.setPaintProperty("location-uncertainty", "circle-opacity", 0.25)
*/
            map.addLayer("location-case", {"type": "circle", "source": "location"}, "waterway-name")
            map.setPaintProperty("location-case", "circle-radius", 10)
            map.setPaintProperty("location-case", "circle-color", "white")

            map.addLayer("location", {"type": "circle", "source": "location"})
            map.setPaintProperty("location", "circle-radius", 15)
            map.setPaintProperty("location", "circle-color", "blue")

            map.addLayer("location-label", {"type": "symbol", "source": "location"})
            map.setLayoutProperty("location-label", "text-allow-overlap", true)
            map.setLayoutProperty("location-label", "icon-allow-overlap", true)
            map.setLayoutProperty("location-label", "icon-image", "position-icon")

            //map.setLayoutProperty("location-label", "text-ignore-placement", true)
            map.setLayoutProperty("location-label", "text-field", tit)
            map.setLayoutProperty("location-label", "text-justify", "left")
            map.setLayoutProperty("location-label", "text-anchor", "top-left")
            map.setPaintProperty("location-label", "text-halo-color", "white")
            map.setPaintProperty("location-label", "text-halo-width", 5)
            console.log(dlug,szer);

        }
    }
    }
    }
}
