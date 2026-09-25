pragma Singleton
import QtQml
import Quickshell.Services.Pipewire

QtObject {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource
  readonly property bool available: !!(sink && sink.audio)
  readonly property bool inputAvailable: !!(source && source.audio)
  readonly property real volume: available ? sink.audio.volume : 0
  readonly property bool muted: available ? sink.audio.muted : false
  readonly property bool inputMuted: inputAvailable ? source.audio.muted : false

  readonly property string icon: {
    if (muted) return "󰖁"
    if (volume >= 0.67) return "󰕾"
    if (volume >= 0.34) return "󰖀"
    if (volume > 0) return "󰕿"
    return "󰝟"
  }

  readonly property string label: {
    if (muted) return "Muted"
    var p = Math.round(volume * 100)
    if (p === 0)   return "Silenced"
    if (p >= 100)  return "Concert hall"
    if (p >= 85)   return "Party mode"
    if (p >= 70)   return "Cranked up"
    if (p >= 50)   return "Steady groove"
    if (p >= 30)   return "Easy listening"
    if (p >= 15)   return "Murmur"
    return "Whisper"
  }

  property var _tracker: PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  function setVolume(v) {
    if (!available) return
    var next = Math.max(0, Math.min(1, v))
    sink.audio.volume = next
    if (sink.audio.muted && next > 0) sink.audio.muted = false
  }

  function toggleMute() {
    if (!available) return
    sink.audio.muted = !sink.audio.muted
  }

  function toggleInputMute() {
    if (!inputAvailable) return
    source.audio.muted = !source.audio.muted
  }
}
