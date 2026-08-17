import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  // hyprsplit gives each monitor its own block of ten workspace ids
  // (mon 1 -> 1-10, mon 2 -> 11-20, ...). The bar is built once per monitor,
  // so each instance renders only its own block, labelled 1-9,0.
  readonly property var window: root.QsWindow.window
  readonly property var monitor: window && window.screen ? Hyprland.monitorFor(window.screen) : null
  readonly property int activeId: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : 0
  readonly property int base: Math.max(0, Math.floor((activeId - 1) / 10) * 10)

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var b = root.base
    var ids = [b + 1, b + 2, b + 3, b + 4, b + 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > b && id <= b + 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  // Focusing a workspace drags it onto whichever monitor is focused, so focus
  // this bar's monitor first — same order as the hyprsplit keybinds.
  function focusWorkspace(id) {
    if (!root.bar || !root.monitor) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ monitor = \"" + root.monitor.name + "\" })")
      + " && hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: root.activeId === modelData
        readonly property int label: ((modelData - 1) % 10) + 1

        bar: root.bar
        text: focused ? "\uDB85\uDCFB" : (label === 10 ? "0" : String(label))
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
