pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications
import "../.."
import "../../Singletons"
import "../../Components/shared/Icons"

PillSurface {
    id: root

    mTop: 14
    mLeft: 16
    mRight: 16
    mBottom: 14

    ameForm: "off"

    property int selectedIndex: 0

    readonly property var entries: {
        var out = [];
        var groups = Notifs.groups || [];
        for (var i = 0; i < groups.length; i++) {
            var g = groups[i];
            for (var c = 0; c < (g.criticals || []).length; c++)
                out.push(g.criticals[c]);
            for (var e = 0; e < (g.entries || []).length; e++)
                out.push(g.entries[e]);
        }
        return out;
    }

    function moveSelection(delta) {
        if (entries.length === 0) {
            selectedIndex = 0;
            return;
        }
        selectedIndex = (selectedIndex + delta + entries.length) % entries.length;
        notifList.positionViewAtIndex(selectedIndex, ListView.Contain);
    }

    function activateSelected() {
        if (selectedIndex >= 0 && selectedIndex < entries.length) {
            Notifs.activateEntry(entries[selectedIndex]);
            requestClose();
        }
    }

    function dismissSelected() {
        if (selectedIndex >= 0 && selectedIndex < entries.length)
            Notifs.dismissEntry(entries[selectedIndex]);
    }

    function toggleDnd() {
        Flags.dnd = !Flags.dnd;
    }

    onEntriesChanged: if (selectedIndex >= entries.length)
        selectedIndex = Math.max(0, entries.length - 1)

    onActiveChanged: {
        if (active) {
            selectedIndex = 0;
            Notifs.markAllSeen();
            notifList.positionViewAtIndex(0, ListView.Beginning);
        }
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Down || event.key === Qt.Key_J)
            moveSelection(1);
        else if (event.key === Qt.Key_Up || event.key === Qt.Key_K)
            moveSelection(-1);
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
            activateSelected();
        else if (event.key === Qt.Key_Delete || event.key === Qt.Key_Backspace)
            dismissSelected();
        else if (event.text === "n" || event.text === "N")
            toggleDnd();
        else if (event.text === "c" || event.text === "C")
            Notifs.clearAll();
        else
            return;
        event.accepted = true;
    }

    Column {
        anchors.fill: parent
        spacing: 8 * root.s

        Item {
            width: parent.width
            height: 30 * root.s

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "報  NOTIFICATIONS"
                color: Theme.cream
                font.family: Theme.font
                font.pixelSize: 11 * root.s
                font.weight: Font.Bold
                font.letterSpacing: 1.4 * root.s
            }

            Text {
                anchors.right: dndChip.left
                anchors.rightMargin: 8 * root.s
                anchors.verticalCenter: parent.verticalCenter
                visible: Notifs.count > 0
                text: Notifs.unread > 0 ? String(Notifs.unread) : ""
                color: Theme.vermLit
                font.family: Theme.font
                font.pixelSize: 9 * root.s
                font.weight: Font.Bold
            }

            Rectangle {
                id: dndChip
                anchors.right: clearChip.left
                anchors.rightMargin: 6 * root.s
                anchors.verticalCenter: parent.verticalCenter
                width: 56 * root.s
                height: 24 * root.s
                radius: 12 * root.s
                color: Flags.dnd ? Theme.frameBg : "transparent"
                border.width: 1
                border.color: Flags.dnd ? Theme.vermDim : Theme.border

                Text {
                    anchors.centerIn: parent
                    text: Flags.dnd ? "DND ON" : "DND OFF"
                    color: Flags.dnd ? Theme.vermLit : Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 8 * root.s
                    font.weight: Font.Bold
                    font.letterSpacing: 0.5 * root.s
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleDnd()
                }
            }

            Rectangle {
                id: clearChip
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 48 * root.s
                height: 24 * root.s
                radius: 12 * root.s
                color: "transparent"
                border.width: 1
                border.color: Theme.border
                visible: Notifs.count > 0

                Text {
                    anchors.centerIn: parent
                    text: "CLEAR"
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 8 * root.s
                    font.weight: Font.Bold
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Notifs.clearAll()
                }
            }
        }

        ListView {
            id: notifList
            width: parent.width
            height: parent.height - 38 * root.s
            clip: true
            model: root.entries
            spacing: 5 * root.s
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: root.selectedIndex

            delegate: Rectangle {
                id: notifRow
                required property var modelData
                required property int index

                width: notifList.width
                height: 58 * root.s
                radius: 10 * root.s
                color: notifList.currentIndex === index ? Theme.frameBg : (rowHover.hovered ? Theme.tileBg : "transparent")
                border.width: notifList.currentIndex === index ? 1 : 0
                border.color: Theme.frameBorder

                HoverHandler {
                    id: rowHover
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.selectedIndex = notifRow.index;
                        Notifs.activateEntry(notifRow.modelData);
                        root.requestClose();
                    }
                }

                Rectangle {
                    id: iconTile
                    anchors.left: parent.left
                    anchors.leftMargin: 8 * root.s
                    anchors.verticalCenter: parent.verticalCenter
                    width: 38 * root.s
                    height: 38 * root.s
                    radius: 8 * root.s
                    color: Theme.tileBg
                    border.width: 1
                    border.color: Theme.border

                    Image {
                        anchors.fill: parent
                        anchors.margins: notifRow.modelData.n.image ? 0 : 7 * root.s
                        source: Notifs.iconFor(notifRow.modelData.n)
                        sourceSize: Qt.size(64, 64)
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 7 * root.s
                        height: 7 * root.s
                        radius: 2 * root.s
                        rotation: 45
                        color: Theme.verm
                        visible: !parent.children[0].visible
                    }
                }

                Text {
                    anchors.left: iconTile.right
                    anchors.leftMargin: 9 * root.s
                    anchors.right: countText.left
                    anchors.rightMargin: 8 * root.s
                    anchors.top: parent.top
                    anchors.topMargin: 9 * root.s
                    text: notifRow.modelData.n.summary
                    color: Theme.cream
                    font.family: Theme.font
                    font.pixelSize: 11 * root.s
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }

                Text {
                    anchors.left: iconTile.right
                    anchors.leftMargin: 9 * root.s
                    anchors.right: dismissText.left
                    anchors.rightMargin: 8 * root.s
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 9 * root.s
                    text: notifRow.modelData.n.body || ""
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 9.5 * root.s
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                Text {
                    id: countText
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * root.s
                    anchors.top: parent.top
                    anchors.topMargin: 8 * root.s
                    visible: notifRow.modelData.count > 1
                    text: "×" + notifRow.modelData.count
                    color: Theme.vermLit
                    font.family: Theme.font
                    font.pixelSize: 9 * root.s
                    font.weight: Font.Bold
                }

                Text {
                    id: dismissText
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * root.s
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8 * root.s
                    text: "✕"
                    color: Theme.dim
                    font.family: Theme.font
                    font.pixelSize: 10 * root.s

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6 * root.s
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Notifs.dismissEntry(notifRow.modelData)
                    }
                }
            }

            Column {
                anchors.centerIn: parent
                visible: root.entries.length === 0
                spacing: 4 * root.s

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "静"
                    color: Theme.ghost
                    font.family: Theme.fontJp
                    font.pixelSize: 32 * root.s
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "NO NOTIFICATIONS"
                    color: Theme.faint
                    font.family: Theme.font
                    font.pixelSize: 9 * root.s
                    font.weight: Font.Bold
                    font.letterSpacing: 1.8 * root.s
                }
            }
        }
    }
}
