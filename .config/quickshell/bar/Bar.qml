import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Config
import qs.workspaces
import qs.clock
import qs.battery
import qs.volume
import qs.network
import qs.power

PanelWindow {
  id: root

  anchors {
    top: true
    left: true
    right: true
  }
  implicitHeight: screen.height * Theme.barHeightRatio
  color: Colors.background

  Workspaces {
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      leftMargin: Theme.barMargin
    }
  }

  Clock {
    anchors.centerIn: parent
  }

  RowLayout {
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: Theme.barMargin
    }
    spacing: Theme.widgetSpacing

    BatteryButton {}
    VolumeButton {}
    NetworkButton {}
    PowerButton {}
  }
}
