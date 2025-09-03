pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

pragma Singleton

Singleton {
	id: root
	property string wifistatus: "default"
	property string ethernetstatus: "default"
	// Timer {
	// 	id: refreshTimer
	// 	interval: 10000 // 10 sec
	// 	running: true
	// 	repeat: true
	// 	onTriggered: {
	// 		powerstatus.running = true
	// 	}
	// }

	Process {
		id: getWifiStatusProc
		running: true
		command: ['bash', '-c', 'nmcli device wifi list']
		//use nmcli for ethernet
		//use nmcli device wifi list for wifi

		stdout: StdioCollector {
			onStreamFinished:{
				//parsing to get name, signal , rate, in use
				root.wifistatus = text.trim()
				console.log(root.wifistatus)
			}
		}
	}

	Process { 
		id: getEthernetStatusProc
		running: true
		command: ['bash', '-c', 'nmcli']
		stdout: StdioCollector{
			onStreamFinished:{
				root.ethernetstatus = text.trim()
				console.log(root.ethernetstatus)
				checkWifiStatus()
			}
		}
	}
	function checkWifiStatus(): void{
		console.log(root.ethernetstatus)
		console.log(root.wifistatus)
	}

	function checkEthernetStatus(ethernet: string){

	}

	function createIcone(): void{

	}
}
