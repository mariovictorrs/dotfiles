pragma Singleton
import QtQml
import qs.services

QtObject {
  id: root

  property bool visible: false
  property string kind: "volume"

  readonly property string icon: {
    if (kind === "brightness") return "󰃠"
    if (kind === "microphone") return AudioService.inputMuted ? "󰍭" : "󰍬"
    return AudioService.icon
  }
  readonly property string label: {
    if (kind === "brightness") return "Brightness"
    if (kind === "microphone") return AudioService.inputMuted ? "Microphone muted" : "Microphone"
    return AudioService.muted ? "Volume muted" : "Volume"
  }
  readonly property real value: {
    if (kind === "brightness") return BrightnessService.percent / 100
    if (kind === "microphone") return AudioService.inputMuted ? 0 : 1
    return AudioService.muted ? 0 : AudioService.volume
  }
  readonly property string valueLabel: {
    if (kind === "brightness") return Math.round(BrightnessService.percent) + "%"
    if (kind === "microphone") return AudioService.inputMuted ? "Muted" : "On"
    return Math.round(AudioService.volume * 100) + "%"
  }

  function show(nextKind) {
    root.kind = nextKind
    root.visible = true
    root.hideTimer.restart()
  }

  function volumeUp() {
    AudioService.setVolume(AudioService.volume + 0.05)
    show("volume")
  }

  function volumeDown() {
    AudioService.setVolume(AudioService.volume - 0.05)
    show("volume")
  }

  function toggleMute() {
    AudioService.toggleMute()
    show("volume")
  }

  function toggleInputMute() {
    AudioService.toggleInputMute()
    show("microphone")
  }

  function brightnessUp() {
    BrightnessService.adjust(5)
    show("brightness")
  }

  function brightnessDown() {
    BrightnessService.adjust(-5)
    show("brightness")
  }

  property var hideTimer: Timer {
    interval: 1500
    onTriggered: root.visible = false
  }
}
