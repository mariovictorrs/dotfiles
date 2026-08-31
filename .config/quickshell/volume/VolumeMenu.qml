import QtQuick
import QtQuick.Controls
import qs.Config
import qs.Components
import qs.Services

PopupWindow {
  id: root

  PopupHeader {
    icon: AudioService.icon
    title: "Audio"
    subtitle: AudioService.label.toUpperCase()
    rightContent: Component {
      Text {
        text: Math.round(AudioService.volume * 100) + "%"
        color: Colors.foreground
        font.pixelSize: Theme.fontSizeLarge
        font.bold: true
      }
    }
  }

  Separator {}

  Column {
    width: parent.width
    spacing: 8

    Text {
      text: "OUTPUT"
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    Slider {
      width: parent.width
      from: 0
      to: 1
      stepSize: 0.05
      value: AudioService.volume
      enabled: AudioService.available
      onMoved: AudioService.setVolume(value)
    }
  }
}
