import QtQuick
import QtQuick.Window
import qs.Config

Window {
  id: root

  required property Item anchor
  property int popupWidth: Theme.popupWidthNormal

  default property alias items: contentColumn.data

  visible: false
  flags: Qt.Popup | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint
  color: "transparent"
  modality: Qt.NonModal
  width: popupWidth
  height: contentColumn.implicitHeight + Theme.popupPadding * 2

  function open() {
    _updateGeometry()
    visible = true
    raise()
    requestActivate()
  }

  function close() {
    visible = false
  }

  function toggle() {
    if (visible) close()
    else open()
  }

  function _updateGeometry() {
    var point = anchor.mapToGlobal(Qt.point(anchor.width - root.width, anchor.height + 10))
    root.x = Math.max(0, point.x)
    root.y = point.y
  }

  onVisibleChanged: if (visible) _updateGeometry()
  onActiveChanged: if (!active && visible) close()

  Rectangle {
    anchors.fill: parent
    radius: Theme.popupRadius
    color: Colors.crust

    Column {
      id: contentColumn
      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        margins: Theme.popupPadding
      }
      spacing: Theme.popupSpacing
    }
  }
}
