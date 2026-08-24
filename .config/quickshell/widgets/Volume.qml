import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell.Services.Pipewire
import qs.Commons

Item {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool hasOutput: !!(sink && sink.audio)
  readonly property real outputVolume: hasOutput ? sink.audio.volume : 0
  readonly property bool outputMuted: hasOutput ? sink.audio.muted : false
  readonly property string volumeLabel: outputMuted ? "Muted" : outputVolumeName(outputVolume, outputMuted)

  function outputVolumeName(volume, muted) {
    if (muted) return "Muted"
    var p = Math.round(volume * 100)
    if (p === 0) return "Silenced"
    if (p >= 100) return "Concert hall"
    if (p >= 85) return "Party mode"
    if (p >= 70) return "Cranked up"
    if (p >= 50) return "Steady groove"
    if (p >= 30) return "Easy listening"
    if (p >= 15) return "Murmur"
    return "Whisper"
  }

  function volumeIcon(volume, muted) {
    if (muted) return ""
    if (volume >= 0.67) return ""
    if (volume >= 0.34) return ""
    if (volume > 0) return ""
    return ""
  }

  function updateMenuGeometry() {
    var point = root.mapToGlobal(Qt.point(root.width - menuWindow.width, root.height + 10))
    menuWindow.x = Math.max(0, point.x)
    menuWindow.y = point.y
  }

  function toggleMenu() {
    if (!hasOutput) return
    if (menuWindow.visible) menuWindow.visible = false
    else {
      updateMenuGeometry()
      menuWindow.visible = true
      menuWindow.raise()
      menuWindow.requestActivate()
    }
  }

  function setVolume(volume) {
    if (!hasOutput) return 0
    var next = Math.max(0, Math.min(1, volume))
    sink.audio.volume = next
    if (sink.audio.muted && next > 0) sink.audio.muted = false
    return next
  }

  function toggleMute() {
    if (!hasOutput) return
    sink.audio.muted = !sink.audio.muted
  }

  visible: hasOutput
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

  Rectangle {
    id: button
    implicitWidth: 28
    implicitHeight: 28
    radius: 10
    color: mouseArea.containsMouse || menuWindow.visible ? Colors.surface0 : Colors.mantle
    border.color: menuWindow.visible ? Colors.accent : Colors.surface1

    Text {
      anchors.centerIn: parent
      text: volumeIcon(outputVolume, outputMuted)
      color: menuWindow.visible ? Colors.accent : (outputMuted ? Colors.warning : Colors.foreground)
      font.pixelSize: 13
      font.bold: true
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: function(mouse) {
        if (mouse.button === Qt.RightButton) toggleMute()
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
    height: menuContent.implicitHeight + 28

    onVisibleChanged: if (visible) updateMenuGeometry()
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
          implicitHeight: Math.max(heroIcon.implicitHeight, heroLabels.implicitHeight, heroPercent.implicitHeight)

          Text {
            id: heroIcon
            text: volumeIcon(outputVolume, outputMuted)
            color: Colors.foreground
            font.pixelSize: 36
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
          }

          Column {
            id: heroLabels
            anchors.left: heroIcon.right
            anchors.leftMargin: 14
            anchors.right: heroPercent.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
              text: "Audio"
              color: Colors.foreground
              font.bold: true
              font.pixelSize: 15
              elide: Text.ElideRight
              width: parent.width
            }

            Text {
              text: volumeLabel.toUpperCase()
              color: Colors.subtext1
              font.pixelSize: 12
              font.bold: true
              font.letterSpacing: 1.2
              elide: Text.ElideRight
              width: parent.width
            }
          }

          Text {
            id: heroPercent
            text: Math.round(outputVolume * 100) + "%"
            color: Colors.foreground
            font.pixelSize: 28
            font.bold: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
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

          Text {
            text: "OUTPUT"
            color: Colors.foreground
            font.bold: true
            font.pixelSize: 15
          }

          Slider {
            id: outputSlider
            width: parent.width
            from: 0
            to: 1
            stepSize: 0.05
            value: outputVolume
            enabled: hasOutput

            onMoved: root.setVolume(value)
          }
        }
      }
    }
  }
}
