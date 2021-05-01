import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: firstPage
    allowedOrientations: Orientation.All


    property variant currentModel: model
    property string topic: "1"
    property string textname
    property string pagetitle: "Bus stops"
    property string combined: "https://api.um.warszawa.pl/api/action/dbstore_get/?id=ab75c33d-3a26-4342-b36a-6e5fef0a3ac3&sortBy=2&apikey=8c2d8817-cd66-4785-a25f-777b58b5ae94"// tid == "" ? source + topic : source + tid

    function resetSearch(){
        searchModel.clear()
        filterField.text = ""
        currentModel = model
        list.scrollToTop()
    }

    function search(filter){
        console.log(model.count);
        for (var j=0; j < model.count; j++){
            if (model.get(j).title.toLowerCase().indexOf(filter) >= 0){
                searchModel.append(model.get(j))
            }
        }
        filterField.focus = false
        currentModel = searchModel
        list.scrollToTop()
    }
    function updatelist(){
        var xhr = new XMLHttpRequest;
        xhr.open("GET", combined);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText);
                list.model.clear();

                for (var i=0;i<data.result.length;i++) {

                    list.model.append({title: data.result[i].values[2].value, zespol: data.result[i].values[0].value, kierunek: data.result[i].values[6].value, slupek: data.result[i].values[1].value});

                }
            }
        }
        xhr.send();
    }

    SilicaListView {
        id:list
        model: currentModel
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
        PullDownMenu {
            id: mainPullDownMenu
            MenuItem {
                text: "About"
                onClicked: pageStack.push("AboutPage.qml");
            }

            MenuItem {
                id: clearFilter
                text: qsTr("Clear filter")
                visible: filterField.text !== ""
                onClicked: {
                    resetSearch()
                }
            }

            Item {

                height: Theme.itemSizeMedium
                width: parent.width
                TextField {
                    id: filterField
                    width: parent.width
                    height: Theme.itemSizeMedium
                    horizontalAlignment: Text.AlignHCenter
                    placeholderText: qsTr("Filter")
                    EnterKey.enabled: text.length > 0
                    EnterKey.onClicked: {
                        searchModel.clear()
                        search(text.toLowerCase())
                        mainPullDownMenu.close()
                    }
                }
            }

        }

        VerticalScrollDecorator {}
        ListModel { id: model}
        ListModel { id: searchModel}

        Component.onCompleted: firstPage.updatelist();


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
                text: title + " " + slupek + " kierunek: " + kierunek
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
                    pageStack.push("SecondPage.qml", {"zespol": zespol, "slupek": slupek, "title": title, "kierunek": kierunek});//, "url": link, "snTitle": title, "discussion": discussion, "commentcount": commentcount });

                }
            }
        }
    }
}

