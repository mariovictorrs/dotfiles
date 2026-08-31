import QtQuick
import Quickshell.Io
import qs.Config
import qs.Components

PopupWindow {
  id: root
  popupWidth: Theme.popupWidthNarrow

  readonly property var actions: [
    { label: "Lock",      icon: "󰌾", command: ["hyprlock"] },
    { label: "Sleep",     icon: "󰤄", command: ["systemctl", "suspend"] },
    { label: "Reboot",    icon: "󰜉", command: ["systemctl", "reboot"] },
    { label: "Power off", icon: "󰐥", command: ["systemctl", "poweroff"] }
  ]

  function runAction(command) {
    if (actionProc.running) return
    root.close()
    actionProc.command = command
    actionProc.running = true
  }

  Process { id: actionProc }

  Column {
    width: parent.width
    spacing: 2

    Text {
      text: "Power"
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    Text {
      text: "System actions"
      color: Colors.subtext1
      font.pixelSize: Theme.fontSizeSmall
    }
  }

  Separator {}

  Column {
    width: parent.width
    spacing: 8

    Repeater {
      model: root.actions

      Rectangle {
        required property var modelData

        width: parent.width
        height: 36
        radius: Theme.itemRadius
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
            font.pixelSize: Theme.fontSizeNormal
          }

          Text {
            text: modelData.label
            color: Colors.foreground
            font.pixelSize: Theme.fontSizeNormal
          }
        }

        MouseArea {
          id: actionMouse
          anchors.fill: parent
          hoverEnabled: true
          enabled: !actionProc.running
          cursorShape: Qt.PointingHandCursor
          onClicked: root.runAction(modelData.command)
        }
      }
    }
  }
}
