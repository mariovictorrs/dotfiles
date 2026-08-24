import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons

RowLayout {
  spacing: 8

  Repeater {
    model: Hyprland.workspaces
    Text { text: modelData.id; color: Colors.foreground }
  }
}
