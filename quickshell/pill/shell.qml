//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import "Singletons"

/**
 * Washi pill top shell. Each monitor carries two layer-shell windows:
 *
 *  - `reserve` is a zero-content strip that only claims an exclusive zone the
 *    height of the rest pill, so tiled windows always sit below the pill even
 *    while it is expanded or a surface is open.
 *  - `overlay` is a full-screen transparent Overlay layer hosting two corner
 *    morphing pills: the left pill owns now-playing and notifications, while
 *    the right pill owns workspaces and system controls. Each surface grows in
 *    place instead of popping up as a separate panel.
 *
 * Input is routed by the window mask. While the pill is collapsed the mask is
 * the pill rect only, so the rest of the screen clicks through to windows.
 * While the pill is expanded (hovered/pinned) or a surface is open the mask is
 * cleared so the whole layer catches clicks. A backdrop press dismisses, and
 * keyboard focus is taken on demand so Escape closes the open surface.
 */
ShellRoot {
    id: root

    property string openMon: ""
    property string openSurface: ""
    property string openSide: ""
    property string peekMon: ""
    property bool scratchpadOpen: false

    onScratchpadOpenChanged: {
        if (root.openSurface === "media" || root.openSurface === "notifications")
            root.openSide = root.scratchpadOpen ? "right" : "left";
    }

    function refresh() {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }

    Component.onCompleted: {
        refresh();
        Devices.restore();
    }

    Binding {
        target: Notifs
        property: "dnd"
        value: Flags.dnd
    }

    PanelWindow {
        id: inhibitWin
        visible: Flags.keepAwake
        implicitWidth: 1
        implicitHeight: 1
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "pill-inhibit"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        anchors { top: true; left: true }
        IdleInhibitor { window: inhibitWin; enabled: Flags.keepAwake }
    }

    /**
     * Only these raw events can change what the pill renders (per-monitor
     * active workspace, minimized toplevels, monitor hotplug). Everything
     * else (window drags, resizes, title spam) must not trigger the triple
     * model refresh, which costs three Hyprland IPC round-trips.
     */
    readonly property var refreshEvents: ({
        workspace: true, workspacev2: true,
        createworkspace: true, createworkspacev2: true,
        destroyworkspace: true, destroyworkspacev2: true,
        moveworkspace: true, moveworkspacev2: true,
        renameworkspace: true, activespecial: true,
        focusedmon: true, focusedmonv2: true,
        openwindow: true, closewindow: true,
        movewindow: true, movewindowv2: true,
        fullscreen: true,
        monitoradded: true, monitoraddedv2: true, monitorremoved: true
    })

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activespecial") {
                const parts = String(event.data || "").split(",");
                const wsName = (parts[0] || "").trim();
                if (wsName === "") {
                    root.scratchpadOpen = false;
                } else {
                    root.scratchpadOpen = wsName.startsWith("special:") || wsName.startsWith("special");
                }
            }
            if (root.refreshEvents[event.name])
                root.refresh();
        }
    }

    function toggleSurface(mon, surface) {
        const side = (root.scratchpadOpen
            ? "right"
            : ((surface === "media" || surface === "notifications") ? "left" : "right"));
        if (root.openMon === mon && root.openSurface === surface && root.openSide === side) {
            root.close();
            return;
        }
        root.openMon = mon;
        root.openSurface = surface;
        root.openSide = side;
    }

    function close() {
        root.openMon = "";
        root.openSurface = "";
        root.openSide = "";
        Qt.callLater(function() {
            Quickshell.execDetached(["hyprctl", "dispatch", "focuscurrentorlast"]);
        });
    }

    function peek(mon) {
        root.peekMon = root.peekMon === mon ? "" : mon;
    }

    function dismiss() {
        root.close();
        root.peekMon = "";
        var popupsCopy = Notifs.popups.slice();
        for (var i = 0; i < popupsCopy.length; i++) {
            Notifs.removePopup(popupsCopy[i]);
        }
    }

    IpcHandler {
        target: "pill"
        function mixer(mon: string): void { root.toggleSurface(mon, "mixer"); }
        function calendar(mon: string): void { root.toggleSurface(mon, "calendar"); }
        function launcher(mon: string): void { root.toggleSurface(mon, "launcher"); }
        function power(mon: string): void { root.toggleSurface(mon, "power"); }
        function link(mon: string): void { root.toggleSurface(mon, "link"); }
        function bluetooth(mon: string): void { root.toggleSurface(mon, "bluetooth"); }
        function notifications(mon: string): void { root.toggleSurface(mon, "notifications"); }
        function battery(mon: string): void { root.toggleSurface(mon, "battery"); }
        function clipboard(mon: string): void { root.toggleSurface(mon, "clipboard"); }
        function wallpaper(mon: string): void { root.toggleSurface(mon, "wallpaper"); }
        function media(mon: string): void {
            if (Mpris.players.values.length > 0)
                root.toggleSurface(mon, "media");
        }
        function peek(mon: string): void { root.peek(mon); }
        function hide(): void { root.close(); }
        function dismiss(): void { root.dismiss(); }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: reserve
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1
            readonly property real topGap: 8 * s
            readonly property real restHeight: 38 * s

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: restHeight + topGap
            aboveWindows: true

            anchors { top: true; left: true; right: true }
            implicitHeight: restHeight + topGap

            mask: emptyReserve
            Region { id: emptyReserve }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay
            required property var modelData
            readonly property real s: modelData ? modelData.height / 1080 : 1
            readonly property real topGap: 2 * s
            readonly property bool compactMode: root.scratchpadOpen
            readonly property string leftSurface: (root.openMon === modelData.name && root.openSide === "left") ? root.openSurface : ""
            readonly property string rightSurface: (root.openMon === modelData.name && root.openSide === "right") ? root.openSurface : ""
            readonly property bool surfaceOpen: leftSurface.length > 0 || rightSurface.length > 0
            readonly property bool modal: surfaceOpen || leftPill.held || rightPill.held


            /**
             * True while this monitor's active workspace holds a real
             * fullscreen window. The pill then retracts off the top edge and
             * the whole layer becomes click-through so fullscreen content owns
             * the screen. Maximize is suppressed globally, so only true
             * fullscreen ever flips this.
             */
            readonly property bool monFullscreen: {
                var mons = Hyprland.monitors.values;
                for (var i = 0; i < mons.length; i++) {
                    if (mons[i].name === modelData.name) {
                        var ws = mons[i].activeWorkspace;
                        var o = ws ? ws.lastIpcObject : null;
                        return o ? !!o.hasfullscreen : false;
                    }
                }
                return false;
            }

            onMonFullscreenChanged: if (monFullscreen && !compactMode) {
                if (root.openMon === modelData.name) root.close();
                if (root.peekMon === modelData.name) root.peekMon = "";
                leftPill.pinned = false;
                rightPill.pinned = false;
            }

            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: surfaceOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand
            WlrLayershell.namespace: "pill"

            anchors { top: true; left: true; right: true; bottom: true }

            mask: (monFullscreen && !compactMode) ? hiddenRegion : (modal ? fullRegion : pillRegion)
            Region { id: hiddenRegion }
            Region {
                id: pillRegion
                readonly property real leftBaseW: Math.max(leftPill.width, leftPill.targetW)
                readonly property real rightBaseW: Math.max(rightPill.width, rightPill.targetW)
                readonly property real unionX: Math.min(leftPill.x, rightPill.x)
                readonly property real unionRight: Math.max(leftPill.x + leftBaseW + leftPill.inputPadRight,
                                                       rightPill.x + rightBaseW + rightPill.inputPadRight)
                x: unionX
                y: Math.min(leftPill.y, rightPill.y)
                width: unionRight - unionX
                height: Math.max(leftPill.height, leftPill.targetH, rightPill.height, rightPill.targetH)
            }
            Region {
                id: fullRegion
                width: overlay.width
                height: overlay.height
            }

            MouseArea {
                anchors.fill: parent
                enabled: overlay.modal
                acceptedButtons: Qt.AllButtons
                onPressed: {
                    if (overlay.surfaceOpen) root.close();
                    else {
                        leftPill.pinned = false;
                        rightPill.pinned = false;
                        root.peekMon = "";
                    }
                }
            }

            FocusScope {
                id: focusScope
                anchors.fill: parent
                focus: overlay.surfaceOpen

                Keys.onEscapePressed: {
                    if (overlay.leftSurface.length > 0) {
                        if (!leftPill.linkBack()) root.close();
                    } else {
                        if (!rightPill.linkBack()) root.close();
                    }
                }
                Keys.onUpPressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationMove(-1); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationMove(-1); e.accepted = true; }
                    else { e.accepted = rightPill.mixerStep(1); }
                }
                Keys.onDownPressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationMove(1); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationMove(1); e.accepted = true; }
                    else { e.accepted = rightPill.mixerStep(-1); }
                }
                Keys.onLeftPressed: (e) => {
                    if (rightPill.mixerOpen) { rightPill.mixerFocusMove(-1); e.accepted = true; }
                    else if (rightPill.wallpaperOpen) { rightPill.wallpaperMove(-1); e.accepted = true; }
                }
                Keys.onRightPressed: (e) => {
                    if (rightPill.mixerOpen) { rightPill.mixerFocusMove(1); e.accepted = true; }
                    else if (rightPill.wallpaperOpen) { rightPill.wallpaperMove(1); e.accepted = true; }
                }
                Keys.onReturnPressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationActivate(); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationActivate(); e.accepted = true; }
                    else if (rightPill.wallpaperOpen) { rightPill.wallpaperActivate(); e.accepted = true; }
                }
                Keys.onEnterPressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationActivate(); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationActivate(); e.accepted = true; }
                    else if (rightPill.wallpaperOpen) { rightPill.wallpaperActivate(); e.accepted = true; }
                }
                Keys.onDeletePressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationDismiss(); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationDismiss(); e.accepted = true; }
                }
                Keys.onBackPressed: (e) => {
                    if (overlay.leftSurface === "notifications") { leftPill.notificationDismiss(); e.accepted = true; }
                    else if (overlay.rightSurface === "notifications") { rightPill.notificationDismiss(); e.accepted = true; }
                }
                Keys.onSpacePressed: (e) => { if (rightPill.wallpaperOpen) { rightPill.wallpaperActivate(); e.accepted = true; } }
                Keys.onPressed: (event) => {
                    if (overlay.leftSurface === "notifications" && event.text.toLowerCase() === "n") {
                        leftPill.notificationToggleDnd(); event.accepted = true;
                    } else if (overlay.rightSurface === "notifications" && event.text.toLowerCase() === "n") {
                        rightPill.notificationToggleDnd(); event.accepted = true;
                    }
                }

                Pill {
                    id: leftPill
                    role: "left"
                    visible: !overlay.compactMode
                    anchors.top: parent.top
                    anchors.topMargin: overlay.topGap
                    anchors.left: parent.left
                    anchors.leftMargin: 12 * overlay.s
                    s: overlay.s
                    screenName: overlay.modelData.name
                    barWindow: overlay
                    surface: overlay.leftSurface
                    forcePinned: root.peekMon === overlay.modelData.name

                    opacity: (overlay.monFullscreen && !overlay.compactMode) ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.morph
                            easing.type: Motion.easeMorph
                            easing.bezierCurve: Motion.morphCurve
                        }
                    }
                    transform: Translate {
                        y: (overlay.monFullscreen && !overlay.compactMode) ? -(leftPill.height + overlay.topGap) : 0
                        Behavior on y {
                            NumberAnimation {
                                duration: Motion.morph
                                easing.type: Motion.easeMorph
                                easing.bezierCurve: Motion.morphCurve
                            }
                        }
                    }

                    HoverHandler { onHoveredChanged: leftPill.hovered = hovered }
                    onRequestSurface: (name) => root.toggleSurface(overlay.modelData.name, name)
                    onRequestClose: root.close()
                }

                Pill {
                    id: rightPill
                    role: overlay.compactMode ? "compact" : "right"
                    anchors.top: parent.top
                    anchors.topMargin: overlay.topGap
                    anchors.right: parent.right
                    anchors.rightMargin: 12 * overlay.s
                    s: overlay.s
                    screenName: overlay.modelData.name
                    barWindow: overlay
                    surface: overlay.rightSurface
                    forcePinned: false

                    opacity: (overlay.monFullscreen && !overlay.compactMode) ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: Motion.morph
                            easing.type: Motion.easeMorph
                            easing.bezierCurve: Motion.morphCurve
                        }
                    }
                    transform: Translate {
                        y: (overlay.monFullscreen && !overlay.compactMode) ? -(rightPill.height + overlay.topGap) : 0
                        Behavior on y {
                            NumberAnimation {
                                duration: Motion.morph
                                easing.type: Motion.easeMorph
                                easing.bezierCurve: Motion.morphCurve
                            }
                        }
                    }

                    HoverHandler { onHoveredChanged: rightPill.hovered = hovered }
                    onRequestSurface: (name) => root.toggleSurface(overlay.modelData.name, name)
                    onRequestClose: root.close()
                }
            }

            onSurfaceOpenChanged: if (surfaceOpen) focusScope.forceActiveFocus()
        }
    }
}
