import QtQuick
import Quickshell
import qs.Commons

Item {
  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Text {
    id: label
    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: Colors.accent
  }
}
