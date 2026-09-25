import QtQuick
import qs.config
import qs.components
import qs.services

BarButton {
  id: root

  menuOpen: menu.visible
  labelText.text: NetworkService.icon + "   " + NetworkService.currentLabel
  labelText.color: menuOpen ? Colors.accent
    : (NetworkService.kind === "disconnected" ? Colors.warning : Colors.foreground)
  implicitWidth: labelText.implicitWidth + Theme.buttonPadding

  onClicked: menu.toggle()
  onRightClicked: NetworkService.toggleWifi()

  NetworkMenu {
    id: menu
    anchor: root
  }
}
