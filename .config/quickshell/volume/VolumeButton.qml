import QtQuick
import qs.Config
import qs.Components
import qs.Services

BarButton {
  id: root

  visible: AudioService.available
  menuOpen: menu.visible
  implicitWidth: Theme.buttonHeight
  labelText.text: AudioService.icon
  labelText.color: menuOpen ? Colors.accent : (AudioService.muted ? Colors.warning : Colors.foreground)

  onClicked: menu.toggle()
  onRightClicked: AudioService.toggleMute()

  VolumeMenu {
    id: menu
    anchor: root
  }
}
