import QtQuick
import QtQuick.Window
import Quickshell.Io
import qs.Commons

Item {
  id: root

  readonly property var powerActions: [
    { label: "Lock", icon: "󰌾", command: ["hyprlock"] },
    { label: "Sleep", icon: "󰤄", command: ["systemctl", "suspend"] },
    { label: "Reboot", icon: "󰜉", command: ["systemctl", "reboot"] },
    { label: "Power off", icon: "󰐥", command: ["systemctl", "poweroff"] }
  ]

  function toggleMenu() {
    if (menuWindow.visible) menuWindow.visible = false
    else {
      updateMenuGeometry()
      menuWindow.visible = true
      menuWindow.raise()
      menuWindow.requestActivate()
    }
  }

  function updateMenuGeometry() {
    var point = root.mapToGlobal(Qt.point(root.width - menuWindow.width, root.height + 10))
    menuWindow.x = Math.max(0, point.x)
    menuWindow.y = point.y
  }

  function runAction(command) {
    if (actionProc.running) return
    menuWindow.visible = false
    actionProc.command = command
    actionProc.running = true
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: actionProc
  }

  Rectangle {
    id: button
    implicitWidth: 28
    implicitHeight: 28
    radius: 10
    color: mouseArea.containsMouse || menuWindow.visible ? Colors.surface0 : Colors.mantle
    border.color: menuWindow.visible ? Colors.error : Colors.surface1

    Text {
      anchors.centerIn: parent
      text: "󰐥"
      color: menuWindow.visible ? Colors.error : Colors.warning
      font.pixelSize: 13
      font.bold: true
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: toggleMenu()
    }
  }

  Window {
    id: menuWindow
    visible: false
    flags: Qt.Popup | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint
    color: "transparent"
    modality: Qt.NonModal
    width: 220
    height: menuContent.implicitHeight + 28

    onVisibleChanged: if (visible) updateMenuGeometry()
    onActiveChanged: if (!active && visible) visible = false

    Rectangle {
      anchors.fill: parent
      radius: 16
      color: Colors.crust
      border.color: Colors.surface1

      Column {
        id: menuContent
        anchors.fill: parent
        anchors.margins: 14
        width: 192
        spacing: 12

        Column {
          spacing: 2

          Text {
            text: "Power"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Text {
            text: "System actions"
            color: Colors.subtext1
            font.pixelSize: 12
          }
        }

        Rectangle {
          width: parent.width
          height: 1
          color: Colors.surface0
        }

        Column {
          width: parent.width
          spacing: 8

          Repeater {
            model: powerActions

            Rectangle {
              required property var modelData
              width: parent.width
              height: 36
              radius: 11
              color: actionMouse.containsMouse ? Colors.surface0 : "transparent"
              opacity: actionProc.running ? 0.5 : 1.0

              Row {
                spacing: 11
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 11

                Text {
                  text: modelData.icon
                  color: Colors.foreground
                  font.pixelSize: 13
                }

                Text {
                  text: modelData.label
                  color: Colors.foreground
                  font.pixelSize: 13
                }
              }

              MouseArea {
                id: actionMouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: !actionProc.running
                cursorShape: Qt.PointingHandCursor
                onClicked: runAction(modelData.command)
              }
            }
          }
        }
      }
    }
  }
}
