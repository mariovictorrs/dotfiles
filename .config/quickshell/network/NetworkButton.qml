import QtQuick
import qs.Config
import qs.Components
import qs.Services

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
