import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell.Networking
import qs.Commons

Item {
  id: root

  readonly property var devices: Networking.devices ? Networking.devices.values : []
  readonly property var wiredDevice: findDevice(DeviceType.Wired)
  readonly property var wifiDevice: findDevice(DeviceType.Wifi)
  readonly property var wifiNetworks: wifiDevice && wifiDevice.networks ? wifiDevice.networks.values : []
  readonly property var connectedWifiNetwork: findConnectedWifiNetwork()
  readonly property bool networkManagerAvailable: Networking.backend === NetworkBackendType.NetworkManager
  readonly property bool wifiStationAvailable: !!wifiDevice
  readonly property bool wifiEnabled: Networking.wifiEnabled

  readonly property string kind: {
    if (wiredDevice && wiredDevice.connected) return "ethernet"
    if (connectedWifiNetwork) return "wifi"
    return "disconnected"
  }

  readonly property int signalStrength: connectedWifiNetwork ? Math.round((connectedWifiNetwork.signalStrength || 0) * 100) : -1
  readonly property string currentLabel: {
    if (kind === "ethernet") return "Ethernet"
    if (connectedWifiNetwork) return connectedWifiNetwork.name || "Wi-Fi"
    return "Offline"
  }

  function findDevice(type) {
    for (var i = 0; i < devices.length; i++) {
      var device = devices[i]
      if (device && device.type === type) return device
    }
    return null
  }

  function findConnectedWifiNetwork() {
    var networks = wifiNetworks || []
    for (var i = 0; i < networks.length; i++) {
      if (networks[i] && networks[i].connected) return networks[i]
    }
    return null
  }

  function wifiIconFor(strength) {
    var icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    var index = Math.max(0, Math.min(4, Math.ceil(strength / 20) - 1))
    return icons[index]
  }

  function connectionIcon() {
    if (kind === "ethernet") return "󰈀"
    if (kind === "wifi") return wifiIconFor(signalStrength)
    return "󰤭"
  }

  function updateMenuGeometry() {
    var point = root.mapToGlobal(Qt.point(root.width - menuWindow.width, root.height + 10))
    menuWindow.x = Math.max(0, point.x)
    menuWindow.y = point.y
  }

  function toggleMenu() {
    if (menuWindow.visible) menuWindow.visible = false
    else {
      updateMenuGeometry()
      if (wifiDevice) wifiDevice.scannerEnabled = true
      menuWindow.visible = true
      menuWindow.raise()
      menuWindow.requestActivate()
    }
  }

  function setScannerEnabled(enabled) {
    if (wifiDevice) wifiDevice.scannerEnabled = enabled
  }

  function toggleWifi() {
    if (!networkManagerAvailable || !wifiStationAvailable) return
    Networking.wifiEnabled = !Networking.wifiEnabled
  }

  function requiresCredentials(network) {
    if (!network) return false
    return network.security !== WifiSecurityType.Open && network.security !== WifiSecurityType.Owe
  }

  function connectNetwork(network) {
    if (!network || network.connected) return
    if (requiresCredentials(network) && !network.known) return
    network.connect()
  }

  function disconnectNetwork(network) {
    if (!network || !network.connected) return
    network.disconnect()
  }

  function toggleNetwork(network) {
    if (!network) return
    if (network.connected) disconnectNetwork(network)
    else connectNetwork(network)
  }

  visible: true
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Rectangle {
    id: button
    implicitWidth: label.contentWidth + 20
    implicitHeight: 28
    radius: 10
    color: mouseArea.containsMouse || menuWindow.visible ? Colors.surface0 : Colors.mantle
    border.color: menuWindow.visible ? Colors.accent : Colors.surface1

    Text {
      id: label
      anchors.centerIn: parent
      text: connectionIcon() + "   " + currentLabel
      color: menuWindow.visible ? Colors.accent : (kind === "disconnected" ? Colors.warning : Colors.foreground)
      font.pixelSize: 13
      font.bold: true
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: function(mouse) {
        if (mouse.button === Qt.RightButton) toggleWifi()
        else toggleMenu()
      }
    }
  }

  Window {
    id: menuWindow
    visible: false
    flags: Qt.Popup | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint
    color: "transparent"
    modality: Qt.NonModal
    width: 320
    height: Math.min(menuContent.implicitHeight + 28, 520)

    onVisibleChanged: {
      if (visible) {
        updateMenuGeometry()
        setScannerEnabled(true)
      } else {
        setScannerEnabled(false)
      }
    }
    onActiveChanged: if (!active && visible) visible = false

    Rectangle {
      anchors.fill: parent
      radius: 16
      color: Colors.crust
      border.color: Colors.surface1

      Column {
        id: menuContent
        anchors.fill: parent
        anchors.margins: 14
        width: 292
        spacing: 12

        Item {
          width: parent.width
          implicitHeight: Math.max(heroIcon.implicitHeight, heroLabels.implicitHeight, heroAction.implicitHeight)

          Text {
            id: heroIcon
            text: connectionIcon()
            color: Colors.foreground
            font.pixelSize: 36
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
          }

          Column {
            id: heroLabels
            anchors.left: heroIcon.right
            anchors.leftMargin: 14
            anchors.right: heroAction.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
              text: "Network"
              color: Colors.foreground
              font.bold: true
              font.pixelSize: 15
              elide: Text.ElideRight
              width: parent.width
            }

            Text {
              text: currentLabel
              color: Colors.subtext1
              font.pixelSize: 12
              font.bold: true
              font.letterSpacing: 1.2
              elide: Text.ElideRight
              width: parent.width
            }
          }

          Switch {
            id: heroAction
            visible: networkManagerAvailable && wifiStationAvailable
            checked: wifiEnabled
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            onToggled: toggleWifi()
          }
        }

        Rectangle {
          width: parent.width
          height: 1
          color: Colors.surface0
        }

        Column {
          width: parent.width
          spacing: 4

          Text {
            text: "Connection"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Text {
            text: kind === "wifi" ? (Math.round(Math.max(0, signalStrength)) + "% signal") : (kind === "ethernet" ? "Wired connection" : "Disconnected")
            color: Colors.subtext1
            font.pixelSize: 12
          }
        }

        Rectangle {
          width: parent.width
          height: 1
          color: Colors.surface0
          visible: wifiNetworks.length > 0
        }

        Column {
          width: parent.width
          spacing: 8
          visible: wifiNetworks.length > 0

          Text {
            text: "Wi-Fi"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
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
                model: wifiNetworks

                Rectangle {
                  required property var modelData
                  width: wifiList.width
                  height: 36
                  radius: 11
                  color: rowMouse.containsMouse ? Colors.surface0 : "transparent"

                  Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 11

                    Text {
                      text: modelData.connected ? wifiIconFor((modelData.signalStrength || 0) * 100) : "󰤮"
                      color: modelData.connected ? Colors.accent : Colors.foreground
                      font.pixelSize: 13
                    }

                    Text {
                      text: modelData.name || "Hidden network"
                      color: modelData.connected ? Colors.accent : Colors.foreground
                      font.pixelSize: 13
                      elide: Text.ElideRight
                      width: 170
                    }

                    Text {
                      visible: modelData.known
                      text: "󰌾"
                      color: Colors.subtext1
                      font.pixelSize: 12
                    }
                  }

                  MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: !requiresCredentials(modelData) || modelData.known || modelData.connected
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toggleNetwork(modelData)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
