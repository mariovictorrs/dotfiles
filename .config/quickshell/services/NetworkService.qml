pragma Singleton
import QtQml
import Quickshell.Networking

QtObject {
  id: root

  readonly property var devices: Networking.devices ? Networking.devices.values : []
  readonly property var wiredDevice: _findDevice(DeviceType.Wired)
  readonly property var wifiDevice: _findDevice(DeviceType.Wifi)
  readonly property var wifiNetworks: wifiDevice && wifiDevice.networks ? wifiDevice.networks.values : []
  readonly property var connectedNetwork: _findConnectedWifi()
  readonly property bool nmAvailable: Networking.backend === NetworkBackendType.NetworkManager
  readonly property bool wifiAvailable: !!wifiDevice
  readonly property bool wifiEnabled: Networking.wifiEnabled

  readonly property string kind: {
    if (wiredDevice && wiredDevice.connected) return "ethernet"
    if (connectedNetwork) return "wifi"
    return "disconnected"
  }

  readonly property int signalStrength: connectedNetwork
    ? Math.round((connectedNetwork.signalStrength || 0) * 100)
    : -1

  readonly property string currentLabel: {
    if (kind === "ethernet") return "Ethernet"
    if (connectedNetwork) return connectedNetwork.name || "Wi-Fi"
    return "Offline"
  }

  readonly property string icon: {
    if (kind === "ethernet") return "󰈀"
    if (kind === "wifi") return wifiIconFor(signalStrength)
    return "󰤭"
  }

  function _findDevice(type) {
    for (var i = 0; i < devices.length; i++) {
      if (devices[i] && devices[i].type === type) return devices[i]
    }
    return null
  }

  function _findConnectedWifi() {
    var nets = wifiNetworks || []
    for (var i = 0; i < nets.length; i++) {
      if (nets[i] && nets[i].connected) return nets[i]
    }
    return null
  }

  function wifiIconFor(strength) {
    var icons = ["󰤯","󰤟","󰤢","󰤥","󰤨"]
    return icons[Math.max(0, Math.min(4, Math.ceil(strength / 20) - 1))]
  }

  function toggleWifi() {
    if (!nmAvailable || !wifiAvailable) return
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
}
