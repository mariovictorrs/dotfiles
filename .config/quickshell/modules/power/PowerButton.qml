import QtQuick
import qs.config
import qs.components

BarButton {
  id: root

  menuOpen: menu.visible
  dangerStyle: true
  implicitWidth: Theme.buttonHeight
  labelText.text: "󰐥"
  labelText.color: menuOpen ? Colors.error : Colors.warning

  onClicked: menu.toggle()

  PowerMenu {
    id: menu
    anchor: root
  }
}
