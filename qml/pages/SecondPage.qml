import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: secondPage

    allowedOrientations: Orientation.All
    property string linia
    property string title
    property string slupek
    property string kierunek
    property string zespol
    property string pagetitle: title + " " + slupek + " " + kierunek
    property string combined: "https://api.um.warszawa.pl/api/action/dbtimetable_get/?id=88cd555f-6f31-43ca-9de4-66c479ad5942&busstopId=" + zespol + "&busstopNr=" + slupek + "&apikey=8c2d8817-cd66-4785-a25f-777b58b5ae94"


    function updatelist(){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", combined);
        console.log(combined);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                list.model.clear();

                for (var i=0;i<data.result.length;i++) {

                    list.model.append({linia: data.result[i].values[0].value});

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

        Component.onCompleted: secondPage.updatelist();


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
                text: linia
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var name = list.model.get(index).name
                    pageStack.push("ThirdPage.qml", {"zespol": zespol, "slupek": slupek, "title": title, "kierunek": kierunek, "linia": linia});//, "url": link, "snTitle": title, "discussion": discussion, "commentcount": commentcount });

                }
            }
        }
    }
}




