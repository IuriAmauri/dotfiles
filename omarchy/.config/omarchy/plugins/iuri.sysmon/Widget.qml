import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "iuri.sysmon"

  property int cpu: 0
  property int mem: 0
  property int disk: 0
  property real memUsedGb: 0
  property real memTotalGb: 0

  // /proc/stat is cumulative since boot, so usage is a delta between samples.
  property int lastBusy: -1
  property int lastTotal: -1

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function refresh() {
    if (!statProc.running) statProc.running = true
  }

  function parse(out) {
    var lines = String(out).trim().split("\n")
    var f = lines[0] ? lines[0].trim().split(/\s+/) : []
    if (f.length < 4) return

    var busy = parseInt(f[0]), total = parseInt(f[1])
    var totalKb = parseInt(f[2]), availKb = parseInt(f[3])

    if (lastTotal >= 0 && total > lastTotal)
      cpu = Math.round(100 * (busy - lastBusy) / (total - lastTotal))
    lastBusy = busy
    lastTotal = total

    memTotalGb = totalKb / 1048576
    memUsedGb = (totalKb - availKb) / 1048576
    mem = Math.round(100 * (totalKb - availKb) / totalKb)
    disk = parseInt(lines[1]) || disk
  }

  Process {
    id: statProc
    command: ["sh", "-c", "awk '/^cpu /{b=$2+$3+$4+$6+$7+$8;t=b+$5} /^MemTotal/{mt=$2} /^MemAvailable/{ma=$2} END{print b,t,mt,ma}' /proc/stat /proc/meminfo; df -P / | awk 'NR==2{print $5}'"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parse(text)
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    fontSize: Style.font.caption
    text: "󰻠 " + root.cpu + "%  󰍛 " + root.mem + "%  󰋊 " + root.disk + "%"
    tooltipText: "CPU: " + root.cpu + "%\n"
      + "Memory: " + root.memUsedGb.toFixed(1) + "G / " + root.memTotalGb.toFixed(1) + "G (" + root.mem + "%)\n"
      + "Disk /: " + root.disk + "% used"
    onPressed: if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
  }
}
