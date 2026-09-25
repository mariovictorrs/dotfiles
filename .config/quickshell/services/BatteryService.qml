pragma Singleton
import QtQml
import Quickshell.Io
import Quickshell.Services.UPower

QtObject {
  id: root

  readonly property var device: UPower.displayDevice
  readonly property bool present: !!(device && device.isPresent)
  readonly property real fraction: present ? Math.max(0, Math.min(1, device.percentage)) : 0
  readonly property bool charging: present && !UPower.onBattery && fraction < 1
  readonly property bool fullyCharged: present && fraction >= 1 && !UPower.onBattery
  readonly property string label: Math.round(fraction * 100) + "%"
  readonly property string powerState: fullyCharged ? "Fully charged" : (charging ? "Charging" : "On battery")
  readonly property real remainingSeconds: present
    ? Number(charging ? device.timeToFull : device.timeToEmpty) || 0
    : 0
  readonly property string remainingLabel: fullyCharged
    ? "Fully charged"
    : (charging ? "Time to full" : "Time remaining")

  readonly property string icon: {
    if (!present) return "󰂄"
    var ci = ["󰢜","󰂆","󰂇","󰂈","󰢝","󰂉","󰢞","󰂊","󰂋","󰂅"]
    var di = ["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]
    var idx = Math.max(0, Math.min(9, Math.floor(fraction * 10)))
    if (fullyCharged) return "󰂅"
    if (charging) return ci[idx]
    return di[idx]
  }

  property string activeProfile: ""
  property bool profilesAvailable: false
  readonly property bool settingProfile: _profileSet.running

  readonly property var profiles: [
    { label: "Saver",       value: "power-saver",  icon: "󰌪" },
    { label: "Balanced",    value: "balanced",      icon: "󰊚" },
    { label: "Performance", value: "performance",   icon: "󰓅" }
  ]

  function formatDuration(totalSeconds) {
    var total = Math.max(0, Math.round(Number(totalSeconds) || 0))
    if (total <= 0) return "—"
    var minutes = Math.max(1, Math.round(total / 60))
    if (minutes < 60) return minutes + " min"
    var hours = Math.floor(minutes / 60)
    var remaining = minutes % 60
    return remaining > 0 ? hours + " h " + remaining + " min" : hours + " h"
  }

  function refreshProfiles() {
    _profileDetect.running = true
    if (profilesAvailable) _profileRead.running = true
  }

  function setProfile(profile) {
    if (settingProfile || !profile || !profilesAvailable) return
    activeProfile = profile
    _profileSet.command = ["powerprofilesctl", "set", profile]
    _profileSet.running = true
  }

  property var _profileDetect: Process {
    command: ["sh", "-c", "command -v powerprofilesctl >/dev/null && echo yes || echo no"]
    stdout: StdioCollector {
      onStreamFinished: {
        root.profilesAvailable = String(text).trim() === "yes"
        if (root.profilesAvailable) root._profileRead.running = true
      }
    }
  }

  property var _profileRead: Process {
    command: ["powerprofilesctl", "get"]
    stdout: StdioCollector {
      onStreamFinished: {
        var value = String(text).trim()
        if (value) root.activeProfile = value
      }
    }
  }

  property var _profileSet: Process {
    onExited: root._profileRead.running = true
  }

  Component.onCompleted: refreshProfiles()
}
