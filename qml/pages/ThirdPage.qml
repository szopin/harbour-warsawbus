import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: thirdPage

    allowedOrientations: Orientation.All
    property int count
    property string linia
    property string czas
    property string symbol1
    property string symbol2
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
        console.log(combined);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                list.model.clear();

                for (var i=0;i<data.result.length;i++) {
                    if (data.result[i].values[1].value === "null"){
                        symbol1 = "";
                    } else symbol1 = data.result[i].values[1].value;

                    if (data.result[i].values[0].value === "null"){
                        symbol2 = "";
                    } else symbol2 = data.result[i].values[0].value;

                    combine = data.result[i].values[5].value.substring(0, 3) + " " + data.result[i].values[5].value.substring(3, 5) + symbol1 + symbol2 +", "

                    for (var j=1;j+i<data.result.length;j++) {
                        if (data.result[i+j].values[5].value.substring(0,3) === data.result[i].values[5].value.substring(0, 3)){
                            if (data.result[i+j].values[1].value === "null"){
                                symbol1 = "";
                            } else symbol1 = data.result[i+j].values[1].value;

                            if (data.result[i+j].values[0].value === "null"){
                                symbol2 = "";
                            } else symbol2 = data.result[i+j].values[0].value;

                            combine = combine + data.result[i+j].values[5].value.substring(3, 5) + symbol1 + symbol2 +", "
                            count++;
                        }
                    }
                    list.model.append({czas: combine});
                    combine = ""
                    i += count;
                    count = 0;
                }
            }
        }
        xhr.send();
    }

    SilicaListView {
        id:list
        ViewPlaceholder {
            id: vplaceholder
            enabled: model.count == 0
            text: "Loading..."

        }

        header: PageHeader {
            title: pagetitle
        }
        anchors.top: header.bottom
        width: parent.width
        height: parent.height


        VerticalScrollDecorator {}
        model: ListModel { id: model}

        Component.onCompleted: thirdPage.updatelist();


        delegate: Item {
            width: parent.width
            height: Theme.itemSizeMedium

            anchors  {

                left: parent.left
                right: parent.right
                margins: Theme.paddingSmall
            }

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

