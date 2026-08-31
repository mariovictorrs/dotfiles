import QtQuick
import QtQuick.Controls
import qs.Config
import qs.Components
import qs.Services

PopupWindow {
  id: root

  onVisibleChanged: {
    if (NetworkService.wifiDevice)
      NetworkService.wifiDevice.scannerEnabled = visible
  }

  PopupHeader {
    icon: NetworkService.icon
    title: "Network"
    subtitle: NetworkService.currentLabel
    rightContent: Component {
      Switch {
        visible: NetworkService.nmAvailable && NetworkService.wifiAvailable
        checked: NetworkService.wifiEnabled
        onToggled: NetworkService.toggleWifi()
      }
    }
  }

  Separator {}

  Column {
    width: parent.width
    spacing: 4

    Text {
      text: "Connection"
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    Text {
      text: NetworkService.kind === "wifi"
        ? (Math.round(Math.max(0, NetworkService.signalStrength)) + "% signal")
        : (NetworkService.kind === "ethernet" ? "Wired connection" : "Disconnected")
      color: Colors.subtext1
      font.pixelSize: Theme.fontSizeSmall
    }
  }

  Separator { visible: NetworkService.wifiNetworks.length > 0 }

  Column {
    width: parent.width
    spacing: 8
    visible: NetworkService.wifiNetworks.length > 0

    Text {
      text: "Wi-Fi"
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    ScrollView {
      width: parent.width
      height: Math.min(wifiList.implicitHeight, 260)
      clip: true
      ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

      Column {
        id: wifiList
        width: parent.width
        spacing: 6

        Repeater {
          model: NetworkService.wifiNetworks

          Rectangle {
            required property var modelData

            width: wifiList.width
            height: 36
            radius: Theme.itemRadius
            color: rowMouse.containsMouse ? Colors.surface0 : "transparent"

            Row {
              spacing: 10
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              anchors.leftMargin: 11

              Text {
                text: modelData.connected
                  ? NetworkService.wifiIconFor((modelData.signalStrength || 0) * 100)
                  : "󰤮"
                color: modelData.connected ? Colors.accent : Colors.foreground
                font.pixelSize: Theme.fontSizeNormal
              }

              Text {
                text: modelData.name || "Hidden network"
                color: modelData.connected ? Colors.accent : Colors.foreground
                font.pixelSize: Theme.fontSizeNormal
                elide: Text.ElideRight
                width: 170
              }

              Text {
                visible: modelData.known
                text: "󰌾"
                color: Colors.subtext1
                font.pixelSize: Theme.fontSizeSmall
              }
            }

            MouseArea {
              id: rowMouse
              anchors.fill: parent
              hoverEnabled: true
              enabled: !NetworkService.requiresCredentials(modelData) || modelData.known || modelData.connected
              cursorShape: Qt.PointingHandCursor
              onClicked: NetworkService.toggleNetwork(modelData)
            }
          }
        }
      }
    }
  }
}
