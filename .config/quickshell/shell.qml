import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Commons

import "./widgets"

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }
  implicitHeight: screen.height * 0.03

  color: Colors.background

  Workspaces {
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      leftMargin: 12
    }
  }

  Clock {
    anchors.centerIn: parent
  }

  RowLayout {
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: 12
    }
    spacing: 16

    Battery {}
    Volume {}
    NetworkWidget {}
    PowerActions {}
  }
}
