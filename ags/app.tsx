import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widget/Bar"
import GLib from "gi://GLib"
import Gtk from "gi://Gtk?version=4.0"
import Applauncher from "./widget/AppLauncher"

let applauncher: Gtk.Window

app.start({
  css: style,
  gtkTheme: "Adwaita",

  requestHandler(request, res) {
    const [, argv] = GLib.shell_parse_argv(request)
    if (!argv) return res("argv parse error")

    switch (argv[0]) {
      case "toggle":
        applauncher.visible = !applauncher.visible
        return res("ok")
      default:
        return res("unknown command")
    }
  },

  main() {
    applauncher = Applauncher() as Gtk.Window
    app.add_window(applauncher)
    applauncher.present()

    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
