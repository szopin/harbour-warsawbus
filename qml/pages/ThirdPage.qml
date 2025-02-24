import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: thirdPage

    allowedOrientations: Orientation.All
    property int count
    property string linia
    property string czas
    property string dlug
    property string szer
    property var symbol1
    property var symbol2
    property string combine
    property string title
    property string slupek
    property string kierunek
    property string zespol
    property string pagetitle: linia + " " + title + " " + slupek + " " + kierunek
    property string combined: "https://api.um.warszawa.pl/api/action/dbtimetable_get/?id=e923fa0e-d96c-43f9-ae6e-60518c9f3238&busstopId=" + zespol + "&busstopNr=" + slupek + "&line=" + linia + "&apikey=8c2d8817-cd66-4785-a25f-777b58b5ae94"

    function updatelist(){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", combined);
        console.log(combined)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                list.model.clear();
const listbus = [];
                for (var i=0;i<data.result.length;i++) {
                    listbus[i] = data.result[i][5].value;
           /*         console.log(data.result[i][1].value)
                    if (data.result[i][1].value == "null"){
                        symbol1 = "";
                    } else symbol1 = data.result[i][1].value;

                    if (data.result[i][0].value == "null"){
                        symbol2 = "";
                    } else symbol2 = data.result[i][0].value;

                    combine = data.result[i][5].value.substring(0, 3) + " " + data.result[i][5].value.substring(3, 5) + symbol1 + symbol2 +", "

                    for (var j=1;j+i<data.result.length;j++) {
                        if (data.result[i+j][5].value.substring(0,3) === data.result[i][5].value.substring(0, 3)){
                            if (data.result[i+j][1].value === "null"){
                                symbol1 = "";
                            } else symbol1 = data.result[i+j][1].value;

                            if (data.result[i+j][0].value === "null"){
                                symbol2 = "";
                            } else symbol2 = data.result[i+j][0].value;

                            combine = combine + data.result[i+j][5].value.substring(3, 5) + symbol1 + symbol2 +", "
                            count++;
                        }
                    }*/
                }
                    listbus.sort();
                    for (var k=0;k<data.result.length;k++) {
                    list.model.append({czas: listbus[k].substring(0, 5)});
                }
                 //   combine = ""
            //        i += count;
           //         count = 0;
          //      }
        //        list.model.append({czas: listbus[i]});
            }
        }
        xhr.send();
    }

    SilicaGridView {
        id:list
    cellWidth: Theme.itemSizeMedium //isPortrait ? width : width / 2
        cellHeight: Theme.itemSizeMedium// isPortrait ? width /2 : width/4
        ViewPlaceholder {
            id: vplaceholder
            enabled: model.count == 0
            text: "Loading..."

        }

        header: PageHeader {
            title: pagetitle
        }
    anchors {
            fill: parent
    }
        anchors.top: header.bottom
        width: parent.width
        height: parent.height

        PullDownMenu {
            id: menu
            MenuItem {
                text: "See " + (linia.length > 2 ? "buses " : "trams ") + "on map"
                onClicked: pageStack.push("Map.qml", { tit: title + " " + slupek, "szer": szer, "dlug": dlug, "linia": linia});
            }
        }

        VerticalScrollDecorator {}
        model: ListModel { id: model}

        Component.onCompleted: thirdPage.updatelist();


        delegate: GridItem {
        //    width: parent.width
        //    height: Theme.itemSizeMedium

       /*     anchors  {

                left: parent.left
      //          right: parent.right
                margins: Theme.paddingSmall
            }*/

            Label {
                id:  theTitle
                text: czas
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }


        }
    }
}

