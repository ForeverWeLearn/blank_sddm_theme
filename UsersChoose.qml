import QtQuick 2.15
import QtQuick.Controls 2.0


Item {
    id: root

    property string text: ""
    property int fontPointSize: usersFontSize
    property string fontFamily: defaultFont

    Text {
        id: username

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: root.fontPointSize
        font.family: root.fontFamily
        color: textColor
        text: root.text

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
}
