import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen

  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  readonly property string screenName: screen ? screen.name : ""
  readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"
  readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)

  readonly property var defaults: ({
      "command": "ai-usage --json",
      "intervalSec": 30,
      "icon": "brain",
      "showIcon": true,
      "showText": true,
      "showWhenUnavailable": true
    })

  readonly property var settings: {
    var base = Object.assign({}, defaults);
    var fromManifest = pluginApi?.manifest?.metadata?.defaultSettings;
    if (fromManifest)
      base = Object.assign(base, fromManifest);
    var fromUser = pluginApi?.pluginSettings;
    if (fromUser)
      base = Object.assign(base, fromUser);
    return base;
  }

  property real usagePercent: -1
  property string usageText: "N/A"
  property string usageStatus: "unknown"
  property string lastUpdated: ""
  property string lastError: ""

  readonly property bool hasUsage: usagePercent >= 0
  readonly property bool showWidget: hasUsage || settings.showWhenUnavailable
  readonly property color valueColor: {
    if (!hasUsage)
      return Color.mOnSurfaceVariant;
    if (usagePercent >= 90)
      return Color.mError;
    return Color.mPrimary;
  }
  readonly property string displayText: {
    if (hasUsage)
      return Math.round(usagePercent) + "%";
    return usageText;
  }
  readonly property string tooltipText: {
    var lines = [];
    lines.push("AI Usage");
    lines.push("Status: " + usageStatus);
    lines.push("Value: " + displayText);
    if (lastUpdated !== "")
      lines.push("Updated: " + lastUpdated);
    if (lastError !== "")
      lines.push("Error: " + lastError);
    return lines.join("\n");
  }

  implicitWidth: showWidget ? content.implicitWidth : 0
  implicitHeight: showWidget ? content.implicitHeight : 0
  visible: showWidget

  function nowString() {
    return Qt.formatDateTime(new Date(), "HH:mm:ss");
  }

  function parseUsagePayload(text) {
    var normalized = {
      "ok": false,
      "percent": -1,
      "status": "unknown",
      "message": "N/A"
    };

    var trimmed = String(text || "").trim();
    if (trimmed === "") {
      normalized.status = "empty";
      normalized.message = "No data";
      return normalized;
    }

    var parsed = null;
    try {
      parsed = JSON.parse(trimmed);
    } catch (e) {
      parsed = null;
    }

    if (parsed !== null) {
      var p = parsed.percent;
      if (p === undefined)
        p = parsed.percentage;
      if (p === undefined)
        p = parsed.usage_percentage;
      if (p === undefined)
        p = parsed.usagePercent;
      if (p === undefined)
        p = parsed.usage;

      if (p !== undefined && !isNaN(Number(p))) {
        var percent = Number(p);
        if (percent >= 0 && percent <= 1)
          percent = percent * 100;
        normalized.percent = Math.max(0, Math.min(100, percent));
        normalized.ok = true;
      }

      if (parsed.status !== undefined)
        normalized.status = String(parsed.status);
      else if (parsed.paused === true)
        normalized.status = "paused";
      else if (normalized.ok)
        normalized.status = "ok";

      var used = parsed.used;
      if (used === undefined)
        used = parsed.used_tokens;
      if (used === undefined)
        used = parsed.current;

      var total = parsed.total;
      if (total === undefined)
        total = parsed.limit;
      if (total === undefined)
        total = parsed.max_tokens;

      if (used !== undefined && total !== undefined) {
        normalized.message = String(used) + "/" + String(total);
      } else if (normalized.ok) {
        normalized.message = Math.round(normalized.percent) + "%";
      } else if (parsed.message !== undefined) {
        normalized.message = String(parsed.message);
      }

      return normalized;
    }

    var percentMatch = trimmed.match(/([0-9]+(?:\.[0-9]+)?)\s*%/);
    if (percentMatch) {
      var simplePercent = Number(percentMatch[1]);
      normalized.percent = Math.max(0, Math.min(100, simplePercent));
      normalized.ok = true;
      normalized.status = "ok";
      normalized.message = Math.round(normalized.percent) + "%";
      return normalized;
    }

    var ratioMatch = trimmed.match(/([0-9]+)\s*\/\s*([0-9]+)/);
    if (ratioMatch) {
      var usedNum = Number(ratioMatch[1]);
      var totalNum = Number(ratioMatch[2]);
      if (totalNum > 0) {
        normalized.percent = Math.max(0, Math.min(100, (usedNum / totalNum) * 100));
        normalized.ok = true;
        normalized.status = "ok";
        normalized.message = ratioMatch[1] + "/" + ratioMatch[2];
        return normalized;
      }
    }

    normalized.status = "unparsed";
    normalized.message = trimmed;
    return normalized;
  }

  function refreshUsage() {
    if (pollProcess.running)
      return;
    pollProcess.running = true;
  }

  Timer {
    id: pollTimer
    interval: Math.max(5, Number(root.settings.intervalSec || 30)) * 1000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.refreshUsage()
  }

  Process {
    id: pollProcess
    command: ["sh", "-lc", String(root.settings.command || "")]
    stdout: StdioCollector { }
    stderr: StdioCollector { }

    onExited: function (exitCode) {
      root.lastUpdated = root.nowString();

      if (exitCode !== 0) {
        root.lastError = String(stderr.text || "").trim();
        if (root.lastError === "")
          root.lastError = "command exited with code " + String(exitCode);
        root.usageStatus = "error";
        root.usageText = "ERR";
        root.usagePercent = -1;
        return;
      }

      var parsed = root.parseUsagePayload(stdout.text || "");
      root.usageStatus = parsed.status;
      root.usageText = parsed.message;
      root.usagePercent = parsed.ok ? parsed.percent : -1;
      root.lastError = parsed.ok ? "" : parsed.message;
    }
  }

  Rectangle {
    id: content
    visible: root.showWidget
    implicitHeight: root.capsuleHeight
    implicitWidth: Math.round(row.implicitWidth + Style.marginXL)
    anchors.centerIn: parent
    radius: Style.radiusM
    color: Style.capsuleColor
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    RowLayout {
      id: row
      anchors.centerIn: parent
      spacing: Style.marginXS

      NIcon {
        visible: root.settings.showIcon
        icon: String(root.settings.icon || "brain")
        pointSize: Style.toOdd(root.capsuleHeight * 0.45)
        applyUiScale: false
        color: root.valueColor
      }

      NText {
        visible: root.settings.showText
        text: root.displayText
        pointSize: root.barFontSize
        applyUiScale: false
        color: root.valueColor
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      hoverEnabled: true
      onEntered: TooltipService.show(content, root.tooltipText, "auto")
      onExited: TooltipService.hide()
      onClicked: root.refreshUsage()
    }
  }
}
