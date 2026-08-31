import QtQuick
import Quickshell
import qs.Config
import qs.Components
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
  color: "transparent"

  Pill {
    anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      leftMargin: Theme.barMargin
    }

    Workspaces {}
  }

  Pill {
    anchors.centerIn: parent

    Clock {}
  }

  Pill {
    id: statusPill

    anchors {
      right: powerPill.left
      verticalCenter: parent.verticalCenter
      rightMargin: Theme.pillGap
    }

    BatteryButton {}
    VolumeButton {}
    NetworkButton {}
  }

  Pill {
    id: powerPill

    round: true
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: Theme.barMargin
    }

    PowerButton {}
  }
}
