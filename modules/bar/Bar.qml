// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.UPower
import "components"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            property real margin: 5
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

			implicitHeight: 30

			Workspace {
				id: workspace
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
			}

			ClockWidget {
				id: clockWidget
				anchors.centerIn: parent
			}

			Rectangle {
				id: container
				color: "white"
				width: 150
				radius: 50
				height: 25
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter

				Text {
					text: "hello"
					color: "black"
					anchors.verticalCenter: parent.verticalCenter
					anchors.centerIn: parent
					font.pixelSize: 12
				}
			}

			// Alternative si UPower n'est pas disponible
		}
	}
}
