import QtQuick
import QtQuick.Window
import Quickshell.Io
import Quickshell.Services.UPower
import qs.Commons

Item {
  id: root
  readonly property bool batteryPresent: {
    var device = UPower.displayDevice
    return !!(device && device.isPresent)
  }

  readonly property real batteryFraction: {
    var device = UPower.displayDevice
    return batteryPresent ? Math.max(0, Math.min(1, device.percentage)) : 0
  }

  readonly property bool charging: batteryPresent && !UPower.onBattery && batteryFraction < 1
  readonly property bool fullyCharged: batteryPresent && batteryFraction >= 1 && !UPower.onBattery
  readonly property string batteryLabel: Math.round(batteryFraction * 100) + "%"
  readonly property string powerState: fullyCharged ? "Fully charged" : (charging ? "Charging" : "On battery")
  readonly property real estimatedRemainingSeconds: batteryPresent
    ? Number(charging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty) || 0
    : 0
  readonly property string estimatedRemainingLabel: fullyCharged ? "Fully charged" : (charging ? "Time to full" : "Time remaining")
  property string activeProfile: ""
  property bool powerProfilesAvailable: false

  readonly property var powerProfiles: [
    { label: "Saver", value: "power-saver", icon: "󰌪" },
    { label: "Balanced", value: "balanced", icon: "󰊚" },
    { label: "Performance", value: "performance", icon: "󰓅" }
  ]

  function batteryIcon() {
    if (!batteryPresent) return "󰂄"

    var chargingIcons = ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
    var defaultIcons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    var index = Math.max(0, Math.min(9, Math.floor(batteryFraction * 10)))

    if (fullyCharged) return "󰂅"
    if (charging) return chargingIcons[index]
    return defaultIcons[index]
  }

  function formatDuration(totalSeconds) {
    var total = Math.max(0, Math.round(Number(totalSeconds) || 0))
    if (total <= 0) return "—"

    var minutes = Math.max(1, Math.round(total / 60))
    if (minutes < 60) return minutes + " min"

    var hours = Math.floor(minutes / 60)
    var remaining = minutes % 60
    return remaining > 0 ? hours + " h " + remaining + " min" : hours + " h"
  }

  function toggleMenu() {
    if (!batteryPresent) return
    if (menuWindow.visible) menuWindow.visible = false
    else {
      updateMenuGeometry()
      menuWindow.visible = true
      menuWindow.raise()
      menuWindow.requestActivate()
    }
  }

  function updateMenuGeometry() {
    if (!batteryPresent) return
    var point = root.mapToGlobal(Qt.point(root.width - menuWindow.width, root.height + 10))
    menuWindow.x = Math.max(0, point.x)
    menuWindow.y = point.y
  }

  function refreshProfiles() {
    profileDetectProc.running = true
    if (powerProfilesAvailable) profileReadProc.running = true
  }

  function setProfile(profile) {
    if (profileSetProc.running || !profile || !powerProfilesAvailable) return
    activeProfile = profile
    profileSetProc.command = ["powerprofilesctl", "set", profile]
    profileSetProc.running = true
  }

  onBatteryPresentChanged: if (!batteryPresent && menuWindow.visible) menuWindow.visible = false
  Component.onCompleted: refreshProfiles()

  visible: batteryPresent
  implicitWidth: batteryPresent ? button.implicitWidth : 0
  implicitHeight: batteryPresent ? button.implicitHeight : 0

  Process {
    id: profileDetectProc
    command: ["sh", "-c", "command -v powerprofilesctl >/dev/null && echo yes || echo no"]
    stdout: StdioCollector {
      onStreamFinished: {
        powerProfilesAvailable = String(text).trim() === "yes"
        if (powerProfilesAvailable) profileReadProc.running = true
      }
    }
  }

  Process {
    id: profileReadProc
    command: ["powerprofilesctl", "get"]
    stdout: StdioCollector {
      onStreamFinished: {
        var value = String(text).trim()
        if (value) activeProfile = value
      }
    }
  }

  Process {
    id: profileSetProc
    onExited: function(code) {
      profileReadProc.running = true
    }
  }

  Rectangle {
    id: button
    implicitWidth: label.implicitWidth + 18
    implicitHeight: 28
    radius: 10
    color: mouseArea.containsMouse || menuWindow.visible ? Colors.surface0 : Colors.mantle
    border.color: menuWindow.visible ? Colors.accent : Colors.surface1

    Text {
      id: label
      anchors.centerIn: parent
      text: batteryIcon() + " " + batteryLabel
      color: menuWindow.visible ? Colors.accent : Colors.warning
      font.pixelSize: 13
      font.bold: true
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: toggleMenu()
    }
  }

  Window {
    id: menuWindow
    visible: false
    flags: Qt.Popup | Qt.FramelessWindowHint | Qt.NoDropShadowWindowHint
    color: "transparent"
    modality: Qt.NonModal
    width: 360
    height: menuContent.implicitHeight + 28

    onVisibleChanged: if (visible) {
      updateMenuGeometry()
      refreshProfiles()
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
        width: 328
        spacing: 12

        Column {
          spacing: 2

          Text {
            text: "Power"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Text {
            text: powerState + " · " + batteryLabel
            color: Colors.subtext1
            font.pixelSize: 12
          }
        }

        Rectangle {
          width: parent.width
          height: 1
          color: Colors.surface0
        }

        Column {
          width: parent.width
          spacing: 2

          Text {
            text: estimatedRemainingLabel
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Text {
            text: formatDuration(estimatedRemainingSeconds)
            color: Colors.subtext1
            font.pixelSize: 12
          }
        }

        Rectangle {
          width: parent.width
          height: 1
          color: Colors.surface0
        }

        Column {
          width: parent.width
          spacing: 8
          visible: powerProfilesAvailable

          Text {
            text: "Power profiles"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Row {
            id: profileRow
            width: parent.width
            spacing: 8

            Repeater {
              model: powerProfiles

              Rectangle {
                required property var modelData
                width: (profileRow.width - profileRow.spacing * 2) / 3
                height: 34
                radius: 10
                color: activeProfile === modelData.value ? Colors.surface0 : "transparent"
                border.color: activeProfile === modelData.value ? Colors.accent : Colors.surface1
                opacity: profileSetProc.running ? 0.5 : 1.0

                Row {
                  spacing: 9
                  anchors.centerIn: parent

                  Text {
                    text: modelData.icon
                    color: activeProfile === modelData.value ? Colors.accent : Colors.foreground
                    font.pixelSize: 13
                  }

                  Text {
                    text: modelData.label
                    color: activeProfile === modelData.value ? Colors.accent : Colors.foreground
                    font.pixelSize: 12
                  }
                }

                MouseArea {
                  anchors.fill: parent
                  hoverEnabled: true
                  enabled: !profileSetProc.running
                  cursorShape: Qt.PointingHandCursor
                  onClicked: setProfile(modelData.value)
                }
              }
            }
          }
        }

      }
    }
  }
}
