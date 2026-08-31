import QtQuick
import qs.Config

Rectangle {
  id: root

  property alias labelText: label
  property bool menuOpen: false
  property bool dangerStyle: false

  signal clicked(var mouse)
  signal rightClicked(var mouse)

  implicitWidth: label.implicitWidth + Theme.buttonPadding
  implicitHeight: Theme.buttonHeight
  radius: Theme.buttonRadius
  color: hoverArea.containsMouse || menuOpen ? Colors.surface0 : Colors.mantle

  Text {
    id: label
    anchors.centerIn: parent
    font.pixelSize: Theme.fontSizeNormal
    font.bold: true
    color: menuOpen
      ? (root.dangerStyle ? Colors.error : Colors.accent)
      : Colors.foreground
  }

  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton) root.rightClicked(mouse)
      else root.clicked(mouse)
    }
  }

  Behavior on color { ColorAnimation { duration: 100 } }
}
