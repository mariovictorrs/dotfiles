import QtQuick
import QtQuick.Layouts
import qs.Config

Rectangle {
  id: root

  default property alias content: layout.children
  property alias spacing: layout.spacing
  property bool round: false

  implicitWidth: round ? implicitHeight : layout.implicitWidth + Theme.pillPaddingH * 2
  implicitHeight: Theme.pillHeight
  radius: height / 2
  color: Colors.mantle

  RowLayout {
    id: layout
    anchors.centerIn: parent
    spacing: Theme.pillSpacing
  }
}
