import QtQuick 2.4
import QtQuick.Controls 2.0


Item {
    id:item1
    width: 400
    height: 400

    property alias lm2: listModel2
    property alias lv2: listView2
    ListView {
        id: listView2
        x: 23
        y: 22
        width: 332
        height: 248
        model: ListModel {
            id: listModel2
            ListElement {
                nickname: "testuser"
                MessageText: "hey everyone whats up!"
            }

            ListElement {
                nickname: "Red"
                MessageText: "red"
            }

            ListElement {
                nickname: "Blue"
                MessageText: "blue"
            }

            ListElement {
                nickname: "Green"
                MessageText: "green"
            }
        }
        delegate: Item {
            x: 5
            width: 80
            height: 40
            Row {
                id: row2
                spacing: 10
                Text {
                    text: nickname
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    color:"blue"
                }
                Text {
                    text: MessageText
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
        }
    }

    Label {
        id: lblBoradcastedMessages1
        x: 89
        y: 0
        text: qsTr("Private messages")
    }

    Label{
        id:lblToNickname
        text:"Private Message To:"
        y:276
        x:23
    }

    property alias txtToNickname: txtToNickname
    TextField{
        id: txtToNickname
        y:lblToNickname.y
        x:lblToNickname.x+lblToNickname.width
    }
    Label{
        id:lblMessage
        text:"Message:"
        y:lblToNickname.y+lblToNickname.height+50
        x:32
    }

    property alias txtMessage: txtMessage
    TextField{
        id: txtMessage
        y:lblMessage.y
        x:lblMessage.x+lblMessage.width
    }

    property alias btnMap: btnMap
    Button {
        id: btnMap
        x: 32
        y: lblMessage.y+lblMessage.height+50
        text: qsTr("Map")
    }
    property alias btnPtivateMessage: btnPtivateMessage
    Button {
        id: btnPtivateMessage
        x: btnMap.x+btnMap.width
        y: btnMap.y
        text: qsTr("Private Message")
    }

}
