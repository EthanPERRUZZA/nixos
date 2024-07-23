import options from "options"
import { matugen } from "lib/matugen"
const mpris = await Service.import("mpris")

const pref = () => options.bar.media.preferred.value

export default (monitor: number) => Widget.Window({
    monitor,
    layer: "bottom",
    name: `desktop${monitor}`,
    class_name: "desktop",
    anchor: ["top", "bottom", "left", "right"],
})
