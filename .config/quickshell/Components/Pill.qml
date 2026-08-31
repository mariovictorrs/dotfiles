import QtQuick
import QtQuick.Layouts
import qs.Config

Rectangle {
  id: root

  default property alias content: layout.children
  property alias spacing: layout.spacing

  implicitWidth: layout.implicitWidth + Theme.pillPaddingH * 2
  implicitHeight: Theme.pillHeight
  radius: height / 2
  color: Colors.mantle

  RowLayout {
    id: layout
    anchors.centerIn: parent
    spacing: Theme.pillSpacing
  }
}
