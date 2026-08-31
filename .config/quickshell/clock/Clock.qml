import QtQuick
import Quickshell
import qs.Config

Text {
  id: root

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: Qt.formatDateTime(clock.date, "hh:mm")
  color: Colors.accent
  font.pixelSize: Theme.fontSizeMedium
  font.bold: true
}
