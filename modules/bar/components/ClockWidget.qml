// ClockWidget.qml
import QtQuick
import "utils"

Rectangle {
	id: container
	color: "white"
	width: 175
	radius: 50
	height: 25
	Text{
		color: "black"
		text: Time.time
		anchors.centerIn: parent

	}
}
