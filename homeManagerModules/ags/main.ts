import "lib/session"
import "style/style"
import init from "lib/init"
import options from "options"
import NotificationPopups from "widget/notifications/NotificationPopups"
import OSD from "widget/osd/OSD"
import { forMonitors } from "lib/utils"

App.config({
    onConfigParsed: () => {
        // setupQuickSettings()
        // setupDateMenu()
        init()
    },
    closeWindowDelay: {
        "launcher": options.transition.value,
        "overview": options.transition.value,
        "quicksettings": options.transition.value,
        "datemenu": options.transition.value,
    },
    windows: () => [
        //...forMonitors(Bar),
        ...forMonitors(NotificationPopups),
        //...forMonitors(ScreenCorners),
        ...forMonitors(OSD),
        // Launcher(),
        // Overview(),
        // PowerMenu(),
        // SettingsDialog(),
        // Verification(),
    ],
})
