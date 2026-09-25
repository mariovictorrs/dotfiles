import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

PanelWindow {
  id: root

  visible: OsdService.visible
  anchors {
    top: true
    left: true
    right: true
  }
  margins.top: Math.round(screen.height * 0.3)
  implicitHeight: card.height
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  Rectangle {
    id: card

    anchors.horizontalCenter: parent.horizontalCenter
    width: 280
    height: 82
    radius: 16
    color: Colors.crust
    border.color: Colors.surface0
    border.width: 1

    Row {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 14

      Text {
        width: 36
        height: parent.height
        text: OsdService.icon
        color: Colors.accent
        font.pixelSize: 30
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
      }

      Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 50
        spacing: 7

        Row {
          width: parent.width

          Text {
            id: label

            text: OsdService.label
            color: Colors.foreground
            font.pixelSize: Theme.fontSizeNormal
            font.bold: true
          }

          Item {
            width: parent.width - label.implicitWidth - valueText.implicitWidth
            height: 1
          }

          Text {
            id: valueText

            text: OsdService.valueLabel
            color: Colors.subtext1
            font.pixelSize: Theme.fontSizeSmall
          }
        }

        Rectangle {
          width: parent.width
          height: 6
          radius: 3
          color: Colors.surface0

          Rectangle {
            width: parent.width * Math.max(0, Math.min(1, OsdService.value))
            height: parent.height
            radius: parent.radius
            color: Colors.accent
          }
        }
      }
    }
  }
}
