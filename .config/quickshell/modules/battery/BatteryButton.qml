import QtQuick
import qs.config
import qs.components
import qs.services

BarButton {
  id: root

  visible: BatteryService.present
  menuOpen: menu.visible
  labelText.text: BatteryService.icon + " " + BatteryService.label
  labelText.color: menuOpen ? Colors.accent : Colors.warning
  implicitWidth: labelText.implicitWidth + Theme.buttonPadding

  onClicked: menu.toggle()

  BatteryMenu {
    id: menu
    anchor: root
  }
}
