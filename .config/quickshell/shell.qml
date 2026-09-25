import Quickshell
import Quickshell.Io
import qs.modules.bar
import qs.modules.osd
import qs.services

ShellRoot {
  Variants {
    model: Quickshell.screens
    Bar {
      required property var modelData
      screen: modelData
    }
  }

  Variants {
    model: Quickshell.screens
    Osd {
      required property var modelData
      screen: modelData
    }
  }

  IpcHandler {
    target: "osd"

    function volumeUp(): void {
      OsdService.volumeUp()
    }

    function volumeDown(): void {
      OsdService.volumeDown()
    }

    function toggleMute(): void {
      OsdService.toggleMute()
    }

    function toggleInputMute(): void {
      OsdService.toggleInputMute()
    }

    function brightnessUp(): void {
      OsdService.brightnessUp()
    }

    function brightnessDown(): void {
      OsdService.brightnessDown()
    }
  }
}
