import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "iuri.vpn"

  property string interfaceName: "Iuri"
  property bool connected: false
  property bool busy: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    checkProc.running = true
  }

  function toggleVpn() {
    if (busy) return
    busy = true
    toggleProc.command = ["sudo", "-n", "wg-quick", connected ? "down" : "up", interfaceName]
    toggleProc.running = true
  }

  // Interface exists => VPN up. No sudo needed for the check.
  Process {
    id: checkProc
    command: ["test", "-d", "/sys/class/net/" + root.interfaceName]
    onExited: function(exitCode) {
      root.connected = exitCode === 0
    }
  }

  Process {
    id: toggleProc
    onExited: function(exitCode) {
      root.busy = false
      root.refresh()
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.connected ? "" : ""
    active: root.connected
    activeColor: "#4caf50"
    tooltipText: root.busy ? "VPN switching…" : (root.connected ? "VPN connected — click to disconnect" : "VPN disconnected — click to connect")
    onPressed: function(b) {
      root.toggleVpn()
    }
  }
}
