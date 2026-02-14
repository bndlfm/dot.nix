import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  spacing: Style.marginM

  required property var pluginApi

  readonly property var defaults: ({
      "command": "ai-usage",
      "intervalSec": 30,
      "icon": "brain",
      "showIcon": true,
      "showText": true,
      "showWhenUnavailable": true
    })

  property var settings: {
    var merged = Object.assign({}, defaults);
    var fromManifest = pluginApi?.manifest?.metadata?.defaultSettings;
    if (fromManifest)
      merged = Object.assign(merged, fromManifest);
    var fromUser = pluginApi?.pluginSettings;
    if (fromUser)
      merged = Object.assign(merged, fromUser);
    return merged;
  }

  function persist() {
    pluginApi.pluginSettings = Object.assign({}, settings);
    pluginApi.saveSettings();
  }

  function saveSettings() {
    persist();
  }

  NTextInput {
    id: commandInput
    Layout.fillWidth: true
    label: "Usage Command"
    description: "Command must print JSON or text containing a percent. Default is the packaged ai-usage helper."
    text: root.settings.command
    placeholderText: "ai-usage"
    onEditingFinished: {
      root.settings.command = text;
      root.persist();
    }
  }

  NSpinBox {
    Layout.fillWidth: true
    label: "Refresh Interval"
    description: "Polling interval in seconds."
    from: 5
    to: 3600
    suffix: "s"
    value: Number(root.settings.intervalSec || 30)
    onValueChanged: {
      root.settings.intervalSec = value;
      root.persist();
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: "Icon"
    description: "Tabler icon name."
    text: root.settings.icon
    placeholderText: "brain"
    onEditingFinished: {
      root.settings.icon = text;
      root.persist();
    }
  }

  NToggle {
    label: "Show Icon"
    checked: root.settings.showIcon
    onToggled: checked => {
      root.settings.showIcon = checked;
      root.persist();
    }
  }

  NToggle {
    label: "Show Text"
    checked: root.settings.showText
    onToggled: checked => {
      root.settings.showText = checked;
      root.persist();
    }
  }

  NToggle {
    label: "Show When Unavailable"
    description: "Keep the widget visible when no usage data is available."
    checked: root.settings.showWhenUnavailable
    onToggled: checked => {
      root.settings.showWhenUnavailable = checked;
      root.persist();
    }
  }
}
