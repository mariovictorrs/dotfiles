pragma Singleton
import QtQml
import Quickshell.Io

QtObject {
  id: root

  property real percent: 0
  property int _pendingAdjustment: 0
  property bool _refreshPending: false

  function refresh() {
    if (_read.running) {
      root._refreshPending = true
      return
    }

    root._refreshPending = false
    _read.running = true
  }

  function adjust(amount) {
    root._pendingAdjustment += amount
    root._runAdjustment()
  }

  function _runAdjustment() {
    if (_adjust.running) return
    if (root._pendingAdjustment === 0) {
      root.refresh()
      return
    }

    var amount = root._pendingAdjustment
    root._pendingAdjustment = 0
    _adjust.command = [
      "brightnessctl",
      "set",
      amount > 0 ? "+" + amount + "%" : Math.abs(amount) + "%-"
    ]
    _adjust.running = true
  }

  property var _read: Process {
    command: ["brightnessctl", "-m"]
    stdout: StdioCollector {
      onStreamFinished: {
        var fields = String(text).trim().split(",")
        var percent = Number.parseFloat(fields[3])
        if (Number.isFinite(percent)) root.percent = percent
      }
    }
    onExited: {
      if (root._refreshPending) root.refresh()
    }
  }

  property var _adjust: Process {
    onExited: root._runAdjustment()
  }

  Component.onCompleted: refresh()
}
