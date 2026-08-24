import QtQuick
import Quickshell.Services.UPower
import qs.Commons

Text {
  text: "bat " + UPower.displayDevice.percentage * 100 + "%"
  color: Colors.success
}
