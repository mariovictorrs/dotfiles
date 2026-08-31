import QtQuick
import qs.Config

Item {
  id: root

  required property string icon
  required property string title
  required property string subtitle
  property Component rightContent: null

  width: parent ? parent.width : 0
  implicitHeight: Math.max(iconText.implicitHeight, labels.implicitHeight,
                            rightLoader.implicitHeight)

  Text {
    id: iconText
    text: root.icon
    color: Colors.foreground
    font.pixelSize: Theme.fontSizeHero
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
    }
  }

  Column {
    id: labels
    anchors {
      left: iconText.right
      leftMargin: 14
      right: rightLoader.visible ? rightLoader.left : parent.right
      rightMargin: rightLoader.visible ? 10 : 0
      verticalCenter: parent.verticalCenter
    }
    spacing: 2

    Text {
      text: root.title
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
      elide: Text.ElideRight
      width: parent.width
    }

    Text {
      text: root.subtitle
      color: Colors.subtext1
      font.pixelSize: Theme.fontSizeSmall
      font.bold: true
      font.letterSpacing: 1.2
      elide: Text.ElideRight
      width: parent.width
    }
  }

  Loader {
    id: rightLoader
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
    }
    visible: root.rightContent !== null
    sourceComponent: root.rightContent
  }
}
