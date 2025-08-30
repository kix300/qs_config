// modules/widgets/components/BatteryIcon.qml
import QtQuick
import Quickshell.Services.UPower

Item {
    id: batteryIcon
    width: 20
    height: 12
    
    property real percentage: 0
    property int state: UPowerDeviceState.Unknown
    
    Rectangle {
        id: batteryBody
        width: parent.width - 4
        height: parent.height
        color: "transparent"
        border.color: "black"
        border.width: 1
        radius: 1
        
        // Niveau de batterie
        Rectangle {
            id: batteryLevel
            width: (parent.width - 2) * (percentage / 100)
            height: parent.height - 2
            anchors {
                left: parent.left
                top: parent.top
                margins: 1
            }
            color: getBatteryColor()
            radius: 1
        }
    }
    
    // Borne positive
    Rectangle {
        width: 2
        height: 4
        color: "black"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
    }
    
    // Icône de charge
    Text {
        visible: state === UPowerDeviceState.Charging
        text: "⚡"
        font.pixelSize: 8
        anchors.centerIn: parent
    }
    
    function getBatteryColor() {
        if (percentage < 20) return "red";
        if (percentage < 50) return "orange";
        return "green";
    }
}
