import QtQuick
import Quickshell
import qs.config
import qs.components
import qs.modules.workspaces
import qs.modules.clock
import qs.modules.battery
import qs.modules.volume
import qs.modules.network
import qs.modules.power

PanelWindow {
  id: root

  anchors {
    top: true
    left: true
    right: true
  }
  margins.top: Theme.barMargin
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
