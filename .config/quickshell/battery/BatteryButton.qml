import QtQuick
import qs.Config
import qs.Components
import qs.Services

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
