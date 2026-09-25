import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config

RowLayout {
  id: root
  spacing: 6

  Repeater {
    model: Math.max(3, Hyprland.workspaces.values.length)

    Rectangle {
      readonly property int workspaceId: index + 1
      readonly property bool active: Hyprland.focusedWorkspace?.id === workspaceId

      implicitWidth: 8
      implicitHeight: 8
      radius: 4
      color: active ? Colors.accent : Colors.surface2
      scale: active ? 1.25 : 1

      Behavior on color { ColorAnimation { duration: 150; easing.type: Easing.OutCubic } }
      Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspaceId + " })")
      }
    }
  }
}
