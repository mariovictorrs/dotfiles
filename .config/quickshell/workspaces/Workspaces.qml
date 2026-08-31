import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Config

RowLayout {
  id: root
  spacing: 6

  Repeater {
    model: Hyprland.workspaces

    Rectangle {
      required property var modelData
      readonly property bool active: Hyprland.focusedWorkspace?.id === modelData.id

      implicitWidth: active ? 24 : 8
      implicitHeight: 8
      radius: 4
      color: active ? Colors.accent : Colors.surface2

      Behavior on implicitWidth { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
      Behavior on color { ColorAnimation { duration: 100 } }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("workspace " + modelData.id)
      }
    }
  }
}
