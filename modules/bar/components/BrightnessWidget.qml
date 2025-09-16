import QtQuick
import QtQuick.Layouts
import qs.services

Item {
    id: root
    width: 20
    height: 20

    Text {
        id: brightnessIcon
        anchors.centerIn: parent
        color: Colors.text
        text: Light.getBrightnessIcon()
    }
}
