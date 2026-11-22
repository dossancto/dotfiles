pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import "Singletons"
import "Components/shared/Icons"

/**
 * 蓄 BATTERY surface: a typographic read-out for the laptop battery. The
 * percentage is the hero, set over a time-to-empty/full subline, with a thin
 * charge meter and an adaptive stat list (Rate / Health / Capacity) beneath a
 * hairline. Health drops when UPower can't report it and the time line drops
 * when no estimate exists; on AC-full the subline reads "Plugged in". Charging
 * warms the percentage, subline and meter to the flame tones. Exposes
 * `implicitHeight` from its content and docks Ame as a soul at the percentage.
 */
PillSurface {
    id: root

    mTop: 16
    mLeft: 19
    mRight: 19
    mBottom: 16

    implicitHeight: content.implicitHeight

    property int selectedDevice: 0

    readonly property var bluetoothDevices: (typeof Bluetooth !== "undefined" && Bluetooth && Bluetooth.devices)
        ? Bluetooth.devices.values : []
    readonly property var upowerDevices: (typeof UPower !== "undefined" && UPower && UPower.devices)
        ? UPower.devices.values : []

    function normalizePct(value) {
        if (value === undefined || value === null)
            return -1;
        var pct = Number(value);
        if (!(pct >= 0))
            return -1;
        if (pct >= 0 && pct <= 1)
            pct *= 100;
        return Math.max(0, Math.min(100, Math.round(pct)));
    }

    function kindFor(name) {
        var n = String(name || "").toLowerCase();
        if (n.indexOf("mouse") >= 0 || n.indexOf("redragon") >= 0)
            return "mouse";
        if (n.indexOf("keyboard") >= 0 || n.indexOf("corne") >= 0 || n.indexOf("kbd") >= 0 || n.indexOf("split") >= 0)
            return "keyboard";
        if (n.indexOf("bud") >= 0 || n.indexOf("earbud") >= 0 || n.indexOf("headset") >= 0 || n.indexOf("headphone") >= 0)
            return "earbuds";
        return "bluetooth";
    }

    readonly property var deviceRows: {
        var rows = [];
        var seen = {};

        if (Battery.present) {
            rows.push({ name: "Laptop", kind: "laptop", pct: Battery.pct, state: Battery.stateLabel, source: "UPower" });
        }

        for (var i = 0; i < upowerDevices.length; i++) {
            var d = upowerDevices[i];
            if (!d || d.isLaptopBattery)
                continue;
            var upct = normalizePct(d.percentage);
            if (upct < 0)
                continue;
            var uname = d.model || d.vendor || d.nativePath || "UPower device";
            var ukey = String(uname).toLowerCase();
            if (seen[ukey])
                continue;
            seen[ukey] = true;
            rows.push({ name: uname, kind: kindFor(uname), pct: upct, state: d.state === undefined ? "" : "UPower", source: "UPower" });
        }

        for (var j = 0; j < bluetoothDevices.length; j++) {
            var b = bluetoothDevices[j];
            if (!b)
                continue;
            var bpct = normalizePct(b.battery);
            if (bpct < 0)
                continue;
            var bname = b.deviceName || b.name || b.address || "Bluetooth device";
            var bkey = String(bname).toLowerCase();
            if (seen[bkey])
                continue;
            seen[bkey] = true;
            rows.push({
                name: bname,
                kind: kindFor(bname),
                pct: bpct,
                state: b.connected ? "Connected" : (b.paired ? "Paired" : ""),
                source: "Bluetooth"
            });
        }

        return rows;
    }

    onDeviceRowsChanged: if (selectedDevice >= deviceRows.length)
        selectedDevice = Math.max(0, deviceRows.length - 1)

    Keys.onUpPressed: (event) => {
        if (deviceRows.length > 0) {
            selectedDevice = (selectedDevice - 1 + deviceRows.length) % deviceRows.length;
            event.accepted = true;
        }
    }
    Keys.onDownPressed: (event) => {
        if (deviceRows.length > 0) {
            selectedDevice = (selectedDevice + 1) % deviceRows.length;
            event.accepted = true;
        }
    }

    readonly property point heroPoint: {
        void root.width;
        void root.height;
        return pctText.mapToItem(root, pctText.width / 2, pctText.height / 2);
    }

    ameForm: open ? "soul" : "off"
    amePoint: heroPoint

    Column {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        Item {
            width: parent.width
            height: 22 * root.s

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8 * root.s

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "蓄"
                    color: Theme.cream
                    font.family: Theme.fontJp
                    font.weight: Font.Medium
                    font.pixelSize: 16 * root.s
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "BATTERY"
                    color: Theme.subtle
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.6 * root.s
                }
            }

            Text {
                visible: Battery.present
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: Battery.stateLabel
                color: Battery.charging ? Theme.flameGlow : Theme.dim
                font.family: Theme.font
                font.pixelSize: 9.5 * root.s
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 1.1 * root.s
            }
        }

        Column {
            visible: Battery.present
            width: parent.width
            topPadding: 16 * root.s
            bottomPadding: 14 * root.s
            spacing: 9 * root.s

            Text {
                id: pctText
                text: Battery.pct + "%"
                color: Battery.low ? Theme.vermLit : (Battery.charging ? Theme.flameGlow : Theme.cream)
                font.family: Theme.font
                font.pixelSize: 46 * root.s
                font.weight: Font.Bold
                font.letterSpacing: -1 * root.s
                font.features: { "tnum": 1 }
            }

            Text {
                readonly property string body: Battery.full
                    ? "Plugged in"
                    : (Battery.hasTime
                        ? Battery.timeStr + (Battery.charging ? " to full" : " remaining")
                        : "")
                visible: body.length > 0
                text: body
                color: Battery.charging ? Theme.flameCore : Theme.subtle
                font.family: Theme.font
                font.pixelSize: 11 * root.s
                font.weight: Font.DemiBold
            }
        }

        Rectangle {
            visible: Battery.present
            width: parent.width
            height: 3 * root.s
            radius: 1.5 * root.s
            color: Theme.threadBg

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * Battery.frac
                radius: parent.radius
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: Battery.charging ? Theme.vermLit : Theme.vermDeep }
                    GradientStop { position: 1.0; color: Battery.charging ? Theme.flameGlow : Theme.vermLit }
                }
            }
        }

        Column {
            width: parent.width
            topPadding: 14 * root.s
            spacing: 5 * root.s
            visible: root.deviceRows.length > 0

            Text {
                text: "DEVICES"
                color: Theme.faint
                font.family: Theme.font
                font.pixelSize: 9 * root.s
                font.weight: Font.Bold
                font.letterSpacing: 1.4 * root.s
            }

            Repeater {
                model: root.deviceRows

                Rectangle {
                    id: deviceRow
                    required property var modelData
                    required property int index
                    width: parent.width
                    height: 34 * root.s
                    radius: 8 * root.s
                    color: root.selectedDevice === index ? Theme.frameBg : "transparent"
                    border.width: root.selectedDevice === index ? 1 : 0
                    border.color: Theme.frameBorder

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectedDevice = deviceRow.index
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 7 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        width: 24 * root.s
                        height: 24 * root.s
                        radius: 7 * root.s
                        color: Theme.tileBg
                        border.width: 1
                        border.color: Theme.border

                        GlyphIcon {
                            anchors.centerIn: parent
                            width: 14 * root.s
                            height: 14 * root.s
                            name: deviceRow.modelData.kind === "bluetooth" ? "bluetooth" : "music"
                            color: deviceRow.modelData.pct <= 20 ? Theme.vermLit : Theme.iconDim
                            stroke: 1.7
                        }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 39 * root.s
                        anchors.right: pctTextRow.left
                        anchors.rightMargin: 8 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 1 * root.s

                        Text {
                            width: parent.width
                            text: deviceRow.modelData.name
                            color: Theme.cream
                            font.family: Theme.font
                            font.pixelSize: 10.5 * root.s
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            text: deviceRow.modelData.kind + (deviceRow.modelData.state ? " · " + deviceRow.modelData.state : "")
                            color: Theme.faint
                            font.family: Theme.font
                            font.pixelSize: 8.5 * root.s
                            elide: Text.ElideRight
                        }
                    }

                    Text {
                        id: pctTextRow
                        anchors.right: parent.right
                        anchors.rightMargin: 8 * root.s
                        anchors.verticalCenter: parent.verticalCenter
                        text: deviceRow.modelData.pct + "%"
                        color: deviceRow.modelData.pct <= 20 ? Theme.vermLit : Theme.cream
                        font.family: Theme.font
                        font.pixelSize: 11.5 * root.s
                        font.weight: Font.Bold
                        font.features: { "tnum": 1 }
                    }
                }
            }
        }

        Column {
            width: parent.width
            topPadding: 16 * root.s
            spacing: 10 * root.s

            component StatRow: Item {
                id: stat
                width: parent ? parent.width : 0
                height: vText.implicitHeight
                property string label: ""
                property string value: ""
                property bool warm: false

                Text {
                    anchors.left: parent.left
                    anchors.baseline: vText.baseline
                    text: stat.label
                    color: Theme.faint
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s
                    font.weight: Font.Medium
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 0.8 * root.s
                }

                Text {
                    id: vText
                    anchors.right: parent.right
                    text: stat.value
                    color: stat.warm ? Theme.flameGlow : Theme.cream
                    font.family: Theme.font
                    font.pixelSize: 12.5 * root.s
                    font.weight: Font.DemiBold
                    font.features: { "tnum": 1 }
                }
            }

            StatRow {
                visible: Math.abs(Battery.rateW) >= 0.05
                label: "Rate"
                value: (Battery.rateW > 0 ? "+" : "−") + Math.abs(Battery.rateW).toFixed(1) + " W"
                warm: Battery.charging
            }

            StatRow {
                visible: Battery.healthSupported
                label: "Health"
                value: Battery.health + "%"
                warm: true
            }

            StatRow {
                visible: Battery.capacityWh >= 1
                label: "Capacity"
                value: Battery.capacityWh.toFixed(1) + " Wh"
            }
        }
    }
}
