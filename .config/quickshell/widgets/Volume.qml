import QtQuick
import Quickshell.Services.Pipewire
import qs.Commons

Item {
  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

  Text {
    id: label
    text: "vol " + Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100) + "%"
    color: Colors.warning
  }
}
