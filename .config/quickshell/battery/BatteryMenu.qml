import QtQuick
import qs.Config
import qs.Components
import qs.Services

PopupWindow {
  id: root
  popupWidth: Theme.popupWidthWide

  onVisibleChanged: if (visible) BatteryService.refreshProfiles()

  PopupHeader {
    icon: BatteryService.icon
    title: BatteryService.powerState
    subtitle: BatteryService.label
  }

  Separator {}

  Column {
    width: parent.width
    spacing: 2

    Text {
      text: BatteryService.remainingLabel
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    Text {
      text: BatteryService.formatDuration(BatteryService.remainingSeconds)
      color: Colors.subtext1
      font.pixelSize: Theme.fontSizeSmall
    }
  }

  Separator {}

  Column {
    width: parent.width
    spacing: 8
    visible: BatteryService.profilesAvailable

    Text {
      text: "Power profiles"
      color: Colors.foreground
      font.bold: true
      font.pixelSize: Theme.fontSizeMedium
    }

    Row {
      id: profileRow
      width: parent.width
      spacing: 8

      Repeater {
        model: BatteryService.profiles

        Rectangle {
          required property var modelData
          readonly property bool active: BatteryService.activeProfile === modelData.value

          width: (profileRow.width - profileRow.spacing * 2) / 3
          height: 34
          radius: Theme.buttonRadius
          color: active ? Colors.surface0 : "transparent"
          opacity: BatteryService.settingProfile ? 0.5 : 1.0

          Row {
            spacing: 9
            anchors.centerIn: parent

            Text {
              text: modelData.icon
              color: active ? Colors.accent : Colors.foreground
              font.pixelSize: Theme.fontSizeNormal
            }

            Text {
              text: modelData.label
              color: active ? Colors.accent : Colors.foreground
              font.pixelSize: Theme.fontSizeSmall
            }
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            enabled: !BatteryService.settingProfile
            cursorShape: Qt.PointingHandCursor
            onClicked: BatteryService.setProfile(modelData.value)
          }
        }
      }
    }
  }
}
