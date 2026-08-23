import Quickshell
import QtQuick
import QtQuick.Layouts

import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Hyprland

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }
  implicitHeight: screen.height * 0.035

  color: Colors.background

  RowLayout {
   anchors {
      left: parent.left
      verticalCenter: parent.verticalCenter
      leftMargin: 12
    }
    spacing: 8

    Repeater {
      model: Hyprland.workspaces
      Text { text: modelData.id; color: Colors.foreground }
    }
  }

  RowLayout {
    anchors.centerIn: parent
    spacing: 8

    Text {
      text: Qt.formatDateTime(clock.date, "hh:mm")
      color: Colors.accent
    }
  }


  RowLayout {
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: 12
    }
    spacing: 16

    Text {
      text: "vol " + Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100) + "%"
      color: Colors.warning
    } PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    Text {
      text: "bat " + UPower.displayDevice.percentage * 100 + "%"
      color: Colors.success
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
