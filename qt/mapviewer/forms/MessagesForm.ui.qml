import QtQuick 2.4
import QtQuick.Controls 2.0


Item {
    id:item1
    width: 400
    height: 400

    property alias lm1: listModel1
    property alias lm2: listModel2
    property alias lv1: listView1
    property alias lv2: listView2
    ListView {
        id: listView1
        x: 32
        y: 41
        width: 334
        height: 113
        model: ListModel {
            id: listModel1
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
                id: row1
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
        id: lblBoradcastedMessages
        x: 86
        y: 29
        text: qsTr("Boradcasted messages")
    }

    ListView {
        id: listView2
        x: 32
        y: 187
        width: 332
        height: 114
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
        x: 78
        y: 171
        text: qsTr("Private messages")
    }

    Label{
        id:lblToNickname
        text:"Private Message To:"
        y:328
        x:32
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

    property alias btnBoradcast: btnBoradcast
    Button {
        id: btnBoradcast
        x: 32
        y: lblMessage.y+lblMessage.height+50
        text: qsTr("Broadcast Message")
    }
    property alias btnPtivateMessage: btnPtivateMessage
    Button {
        id: btnPtivateMessage
        x: btnBoradcast.x+btnBoradcast.width
        y: btnBoradcast.y
        text: qsTr("Private Message")
    }

}
